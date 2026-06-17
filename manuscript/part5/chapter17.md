# 第17章 複数箇所を同時に更新する

## この章のねらい

第16章で、作成時に「一覧へ prepend」「フォームを update」「flash を update」という 3 つの命令を、1 レスポンスで送りました。この章では、その「複数箇所の同時更新」を、実務で必要になる形へ広げます。

件数バッジの更新、最後の 1 件を消したときの空状態の表示、partial の共通化、そして命令の宛先を支える `dom_id` の設計です。最後に、画面が遷移なしで変わるときのアクセシビリティの入口にも触れます。

## 17.1 1 レスポンスに複数 stream を含める

まず、削除を例に、複数の命令を 1 レスポンスにまとめます。タスクを 1 件削除したら、次の 3 か所を同時に更新したいとします。

- 一覧から、その行を消す
- 件数バッジを、新しい件数にする
- 「削除しました」とフラッシュを出す

`destroy.turbo_stream.erb` に、命令を並べます。

`app/views/tasks/destroy.turbo_stream.erb`

```erb
<%= turbo_stream.remove @task %>
<%= turbo_stream.update "task_count" do %><%= Task.count %><% end %>
<%= turbo_stream.update "flash", partial: "layouts/flash" %>
```

第14章で「frame では 1 か所しか差し替えられないので応えられない」とした要求が、Turbo Streams なら 3 つの命令で実現できます。命令を並べるだけです。

## 17.2 カウンター更新

件数バッジは、一覧のどこかに置いた要素です。`id` を付けておきます。

`app/views/tasks/index.html.erb`（抜粋）

```erb
<span id="task_count"><%= Task.count %></span> 件
```

更新は、17.1 で見たとおり `turbo_stream.update "task_count"` です。作成時にも増やしたいので、`create.turbo_stream.erb` にも同じ命令を足します。

```erb
<%= turbo_stream.update "task_count" do %><%= Task.count %><% end %>
```

ここでは全タスクの件数（`Task.count`）を出していますが、実際には「いま表示している一覧に合わせた件数」を出します。プロジェクトごとの一覧なら、そのプロジェクトのタスク数にします。件数の出し方を、一覧の絞り込みと揃えるのがポイントです。

## 17.3 空状態の表示

ここで、削除に 1 つ落とし穴があります。`remove` で行を消すと、最後の 1 件を消したとき、一覧の入れ物が<strong>空っぽ</strong>になります。「タスクはありません」のような案内が出ず、ただの空白になってしまいます。

これを防ぐには、一覧の領域を、空のときの表示も含めて 1 つの partial にまとめ、変化のたびにその領域ごと描き直すのが簡単です。

`app/views/tasks/_tasks.html.erb`

```erb
<div id="tasks">
  <% if tasks.any? %>
    <%= render tasks %>
  <% else %>
    <p>タスクはありません。</p>
  <% end %>
</div>
```

そして、削除では行だけを `remove` するのではなく、この領域を `replace` で描き直します。

`app/views/tasks/destroy.turbo_stream.erb`（空状態に対応した形）

```erb
<%= turbo_stream.replace "tasks", partial: "tasks/tasks", locals: { tasks: Task.all } %>
<%= turbo_stream.update "task_count" do %><%= Task.count %><% end %>
<%= turbo_stream.update "flash", partial: "layouts/flash" %>
```

`remove` は 1 行だけを正確に消せる軽い方法ですが、空状態を別に面倒見る必要があります。領域ごと `replace` する方法は、一覧をまるごと描き直すので少し重い代わりに、空状態を自然に扱えます。<strong>「精密に消すか、領域ごと描き直すか」は設計判断です。</strong>空状態のような分岐が要るときは、領域ごと描き直す方が素直です。

## 17.4 partial の共通化

17.3 で、一覧の領域を `_tasks` partial にまとめました。ここで効いてくるのが、partial の共通化です。

この `_tasks` partial は、最初の一覧表示（`index`）でも、削除後の描き直し（stream）でも、同じものを使います。

`app/views/tasks/index.html.erb`（抜粋）

```erb
<%= render "tasks", tasks: @tasks %>
```

もし、一覧の見た目を一覧画面と stream で別々に書いていたら、修正のたびに両方を直す羽目になります。「最初の表示」と「部分更新」で同じ partial を使うことが、Turbo Streams を使った設計の土台です。第16章で `_task`（1 件の表示）を一覧と stream で共通化したのと、同じ考え方です。

## 17.5 id 設計と `dom_id`

ここまで、`turbo_stream.replace @task` や `turbo_stream.remove @task` のように、命令の宛先をモデルから指定してきました。これを支えているのが `dom_id` です。

`dom_id(task)` は、`"task_1"` のような文字列を返します。第12章で `_task` を `turbo_frame_tag task` で囲んだとき、その frame の `id` は `dom_id(task)` ＝ `"task_1"` でした。そして stream の `turbo_stream.replace @task` も、同じ `dom_id(@task)` を target にします。<strong>表示側の `id` と、命令側の target が、`dom_id` で自動的に一致する</strong>のです。

だから、`id` を手で書いてはいけません。`<div id="task_1">` のように手書きすると、モデルの `id` がずれた瞬間に target と合わなくなります。`dom_id` を使えば、表示も命令も同じ規則で `id` が決まり、ずれません。

`dom_id` には、接頭辞も付けられます。

```ruby
dom_id(task)            # => "task_1"
dom_id(task, :edit)     # => "edit_task_1"
dom_id(Task.new)        # => "new_task"
```

同じレコードに複数の枠（表示用、編集用など）を持たせたいときは、接頭辞で `id` を分けます。コンテナの `id`（`"tasks"`、`"task_count"`、`"flash"`）と合わせて、`id` の付け方を最初に決めておくと、stream の宛先がぶれません。

## 17.6 アクセシブルな更新通知の入口

Turbo Streams は、ページ遷移なしで画面を書き換えます。目で見ているユーザーには自然ですが、<strong>スクリーンリーダーを使うユーザーには、更新が起きたことが伝わらない</strong>ことがあります。画面の一部が静かに変わるだけだからです。

これを補う入口が、`aria-live` です。更新を読み上げてほしい領域に付けます。たとえばフラッシュの入れ物に付けると、フラッシュが更新されたとき、その内容が読み上げられます。

```erb
<div id="flash" role="status" aria-live="polite">
  <%= render "layouts/flash" %>
</div>
```

`role="status"` は、`aria-live="polite"`（手が空いたときに読み上げる）を含む役割です。操作の結果を伝えるフラッシュに向いています。

ここでは「部分更新には読み上げの配慮が要る」という入口だけ押さえます。フォーカスの移動や、件数・エラーの読み上げといった本格的な作り込みは、第7部（実務で使う Hotwire UI パターン）と、その a11y チェックリストで扱います。

> 第17章では、複数箇所の同時更新を、件数・空状態・partial 共通化・`dom_id`・読み上げの観点で設計しました。ここまでは「自分の操作」がきっかけでした。次の第18章では、Action Cable を使って、「他のユーザーの操作」をきっかけに、同じ更新を全員へ配信します。

## 参考資料

- Turbo Streams（Handbook）: <https://turbo.hotwired.dev/handbook/streams>
- Turbo Streams リファレンス: <https://turbo.hotwired.dev/reference/streams>
- Rails API: `dom_id`（ActionView::RecordIdentifier）: <https://api.rubyonrails.org/classes/ActionView/RecordIdentifier.html>
- MDN: ARIA live regions: <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Live_Regions>
