# 第23章 検索と絞り込み

## この章のねらい

第7部では、ここまでの Turbo と Stimulus を組み合わせて、実務でよく出る UI を作ります。最初は検索と絞り込みです。

この章で作るのは、入力に追従して一覧だけが絞り込まれ、しかも結果を URL で共有・リロードできる検索です。Turbo Frames が「1 か所だけを差し替える」代表例だと体得します。

> この部では、各章で次の 3 つの問いを使い回します。サーバーの状態が要るか／更新は 1 か所か複数か／きっかけは誰か。検索は「サーバーの状態が要る・更新は一覧 1 か所・きっかけは自分」なので、Turbo Frames が向きます。

## 23.1 完成イメージ

タスク一覧の上部に、検索ボックスとステータスの絞り込みを置きます。文字を入力すると、少し待って一覧だけが絞り込まれます。`/tasks?q=...&status=...` のように URL にも条件が反映され、その URL を共有・リロードしても同じ結果が出ます。

## 23.2 この章の選択

更新したいのは一覧の 1 か所だけです。だから Turbo Frames を使います。検索フォームは状態を変えない読み取りなので、GET です（第8章）。入力への追従は、サーバー往復の要らない部分なので Stimulus が担います。

## 23.3 通常の GET 検索を作る

まず、Hotwire を使わない普通の検索から始めます。controller で、パラメータに応じて絞り込みます。

`app/controllers/tasks_controller.rb`（`index`）

```ruby
def index
  @tasks = Task.all
  if params[:q].present?
    @tasks = @tasks.where("title LIKE ?", "%#{Task.sanitize_sql_like(params[:q])}%")
  end
  @tasks = @tasks.where(status: params[:status]) if params[:status].present?
end
```

`LIKE` の値は `?` でバインドしているので、SQL インジェクションは防げます。さらに `Task.sanitize_sql_like` を通して、ユーザー入力に含まれる `%` や `_` を、ワイルドカードではなくただの文字として扱えるようにしています。

検索フォームは、`tasks_path` への GET です。

`app/views/tasks/index.html.erb`（抜粋）

```erb
<%= form_with url: tasks_path, method: :get do |form| %>
  <%= form.search_field :q, value: params[:q] %>
  <%= form.select :status, Task.statuses.keys, { include_blank: "すべて", selected: params[:status] } %>
  <%= form.submit "検索" %>
<% end %>

<%= render "tasks", tasks: @tasks %>
```

この時点では、検索するとページ全体が再描画されます（Turbo Drive 経由なので白い画面は出ませんが、ページ全体の visit です）。

## 23.4 一覧を frame で囲む

一覧だけを差し替えるために、結果を frame で囲みます。

`app/views/tasks/index.html.erb`（抜粋）

```erb
<%= form_with url: tasks_path, method: :get, data: { turbo_frame: "task_list" } do |form| %>
  <%= form.search_field :q, value: params[:q] %>
  <%= form.select :status, Task.statuses.keys, { include_blank: "すべて", selected: params[:status] } %>
  <%= form.submit "検索" %>
<% end %>

<%= turbo_frame_tag "task_list" do %>
  <%= render "tasks", tasks: @tasks %>
<% end %>
```

フォームに `data-turbo-frame="task_list"` を付けました。これで、検索の GET は `id="task_list"` の frame だけを差し替えます（第11章）。`index` のレスポンスにも同じ frame があるので、結果の部分だけが入れ替わります。検索ボックスやヘッダーは動きません。

## 23.5 Stimulus で requestSubmit を debounce する

「検索」ボタンを押さなくても、入力に追従して絞り込みたいところです。Stimulus で、入力のたびにフォームを送信します。ただし、1 文字ごとに送るとリクエストが多すぎるので、少し待ってから送る（debounce）ようにします。

`app/javascript/controllers/search_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
```

フォームに controller と action を付けます。

```erb
<%= form_with url: tasks_path, method: :get,
      data: { turbo_frame: "task_list", controller: "search", action: "input->search#submit" } do |form| %>
```

action は form 要素に付けているので、子要素から伝わってくる `input` イベントを拾います。検索ボックスの入力に加え、ステータスの `<select>` も変更時に `input` イベントを発火するため、同じく拾えます（明示したいときは `change->search#submit` も併記します）。入力のたびに `submit` が呼ばれ、300 ミリ秒待ってから `this.element.requestSubmit()` でフォームを送信します。`requestSubmit()` は、ボタンを押したのと同じようにフォームを送り、Turbo がそれを横取りして frame を差し替えます。待ち時間は Values で持たせているので（第21章）、HTML 側から変えられます。

## 23.6 `data-turbo-action="advance"` で履歴に積む

ここまでで一覧は絞り込めますが、1 つ問題があります。frame の差し替えでは URL が変わりません（第11章）。検索結果を共有・リロードできるようにするには、URL に条件を反映させる必要があります。

frame に `data-turbo-action="advance"` を付けます。

```erb
<%= turbo_frame_tag "task_list", data: { turbo_action: "advance" } do %>
  <%= render "tasks", tasks: @tasks %>
<% end %>
```

`advance` を付けると、frame の差し替えに合わせてブラウザの URL も更新されます。`/tasks?q=bug&status=todo` のような URL になり、共有・リロード・戻る操作に耐えます。検索条件が URL に残るので、誰かに送れば同じ結果が再現できます。

## 23.7 フレーム外を更新したくなったときの判断

「検索結果の件数も出したい」となったとき、件数バッジを frame の外に置くと、frame の差し替えでは更新できません（第14章）。一覧という 1 か所だけを差し替えているからです。

選択肢は 2 つです。

- 件数バッジを `task_list` frame の<strong>中</strong>に置く。こうすれば、結果と一緒に更新されます。検索の範囲では、これがいちばん素直です。
- どうしても frame の外（離れた場所）に件数を置きたいなら、Turbo Streams へ切り替えます（第5部）。複数箇所の同時更新は Streams の領分です。

まずは frame の中に収める。収まらなくなったら Streams を検討する。この判断軸（第14章）が、ここでも効きます。

## 23.8 a11y

検索は、目で見ているユーザーには自然ですが、配慮が要ります。

- 結果の frame に `aria-live="polite"` を付け、絞り込みの結果が読み上げられるようにします。件数（「3 件見つかりました」など）を結果の中に出すと、より親切です。
- 入力に追従して送信するので、フォーカスは検索ボックスに留めます。`requestSubmit()` はフォーカスを動かさないので、入力を続けられます。

```erb
<%= turbo_frame_tag "task_list", data: { turbo_action: "advance" }, aria: { live: "polite" } do %>
  <p><%= @tasks.size %> 件</p>
  <%= render "tasks", tasks: @tasks %>
<% end %>
```

## 23.9 テスト

検索は、System Test と Request Test で役割を分けて確かめます。

- System Test … 入力すると一覧が絞り込まれる、という「画面の振る舞い」を確かめます。Stimulus の debounce や frame の差し替えを含みます。
- Request Test … パラメータに対して、controller が正しい結果を返すという「サーバーの絞り込み」を確かめます。`get tasks_path(q: "bug")` で、期待する件数・内容になるかを見ます。

System Test だけだと、絞り込み条件の網羅が重くなります。条件の組み合わせは Request Test で、画面の追従は System Test で、と分けると、軽く確実にテストできます。

## 23.10 アンチパターン

- <strong>debounce なし</strong>。1 文字ごとに送ると、リクエストが大量に飛びます。必ず待ちを入れます。
- <strong>URL に条件を残さない</strong>。frame の差し替えだけで `advance` を付けないと、共有もリロードもできません。
- <strong>単一箇所なのに Streams で全置換</strong>。一覧 1 か所の更新なら frame で十分です。なんでも Streams にすると、かえって複雑になります。

> 第23章では、検索を Turbo Frames＋Stimulus で作り、URL に条件を残しました。次の第24章では、件数の多い一覧を扱うページネーションと無限スクロールを学びます。

## 参考資料

- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
- Turbo の属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
- Stimulus リファレンス（Actions / Values）: <https://stimulus.hotwired.dev/reference/actions>
- MDN: ARIA live regions: <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Live_Regions>
