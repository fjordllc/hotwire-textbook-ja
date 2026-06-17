# 第25章 バリデーションエラーとフォーム UX

## この章のねらい

フォームは、Hotwire でいちばんつまずきやすいところです。第8章で「成功は redirect、失敗は 422 でフォーム再描画」という契約を学びました。この章では、その契約を土台に、フォームの体験（UX）とアクセシビリティを仕上げます。

エラーをその場に出す、送信中を示す、二重送信を防ぐ、そしてスクリーンリーダーにエラーを正しく伝える。実務のフォームに必要な要素を、Relay のタスク作成・編集で組み立てます。

## 25.1 完成イメージ

入力が不正なら、ページ遷移せずに、フォームのその場にエラーが表示されます。フォーカスはエラーの位置に移り、スクリーンリーダーにもエラーが伝わります。成功すれば、一覧とフラッシュが更新されます。送信中はボタンが押せなくなり、二重送信が防がれます。

## 25.2 この章の選択

主役は<strong>サーバー側のバリデーション</strong>です。Rails のモデルが検証し、失敗を 422 で返します。Stimulus は、あくまで補助です。送信中の表示や文字数カウンタなど、体験をよくする役割に徹し、サーバー検証の代わりにはしません。

## 25.3 失敗時に 422 を返す

第8章・第16章で見たとおり、保存に失敗したら 422 を返します。コードでは `status: :unprocessable_entity` です。

```ruby
if @task.save
  # 成功時の応答（25.5）
else
  # 失敗時: フォームを 422 で返す
end
```

Turbo は、422 で返ってきた HTML を画面に反映します。成功時にうっかり 200 で render すると、Turbo は再描画せず送信元の URL に留まります（第8章）。失敗は必ず 422、と徹底します。

## 25.4 フォームを同じ場所に戻す

失敗時は、入力中のフォームを、エラー付きで同じ場所に戻します。やり方は、これまでに学んだ 2 つのどちらかです。

- インライン編集のように frame の中で完結しているなら、frame に 422 のフォームを返します（第12章）。
- 一覧ページの inline フォームなら、Turbo Streams でフォーム領域を差し替えます（第16章）。

どちらも、ページ遷移せずに、エラーの付いたフォームがその場に現れ、ユーザーは入力をやり直せます。

## 25.5 成功時に一覧と flash を更新する

成功時は、第16章・第17章の Turbo Streams で、複数箇所を同時に更新します。

```erb
<%= turbo_stream.prepend "tasks", @task %>
<%= turbo_stream.update "new_task_form" do %>
  <%= render "form", task: Task.new %>
<% end %>
<%= turbo_stream.update "flash", partial: "layouts/flash" %>
```

新しいタスクを一覧に追加し、フォームを空に戻し、フラッシュを出します。フォームの成功・失敗が、どちらもページ遷移なしで完結します。

## 25.6 Stimulus で補助する

ここから、体験をよくする補助です。

<strong>送信中の表示と二重送信の防止</strong>は、実は Turbo に組み込みの助けがあります。Turbo はフォーム送信中、送信ボタンを自動で無効にします。さらに、ボタンに `data-turbo-submits-with` を付けると、送信中だけ文言を差し替えられます。

```erb
<%= form.submit "作成", data: { turbo_submits_with: "作成中…" } %>
```

これだけで、送信中はボタンが「作成中…」になり、押せなくなります。二重送信の多くは、これで防げます。

<strong>文字数カウンタ</strong>のような入力中の補助は、第20章で作った Stimulus の controller を使います。これらは入力体験を助けるもので、サーバー検証とは別物です。

## 25.7 a11y

フォームのアクセシビリティは、この章の主戦場です。エラーを「見える」だけでなく「伝わる」ようにします。

- <strong>エラーサマリ</strong>。フォームの先頭に、エラーの一覧を出します。`role="alert"` を付けると、表示時に読み上げられます。さらに、再描画後にここへフォーカスを移すと、ユーザーはすぐエラーに気づけます。フォーカス移動は、第19章で作った `autofocus` controller（`connect` で `this.element.focus()` する）を再利用します。`connect` は frame の差し替えでも Turbo Streams の差し込みでも呼ばれるので、どちらの経路で 422 が返っても確実にフォーカスが移ります（HTML の `autofocus` 属性は frame／ページの描画後には効きますが、stream で差し込んだ要素には効かないため、`connect` 方式に寄せます）。
- <strong>各フィールドの紐づけ</strong>。エラーのあるフィールドに `aria-invalid="true"` を付け、`aria-describedby` でそのフィールドのエラーメッセージと結びつけます。`aria-invalid` は、エラーがないときは `"false"`（妥当である、という意味）になります。これは仕様どおりで問題ありません。

```erb
<% if task.errors.any? %>
  <div role="alert" tabindex="-1" data-controller="autofocus">
    <%= pluralize(task.errors.count, "件") %>のエラーがあります。
  </div>
<% end %>

<%= form.text_field :title,
      "aria-invalid": task.errors[:title].any?,
      "aria-describedby": ("title_error" if task.errors[:title].any?) %>
<% if task.errors[:title].any? %>
  <span id="title_error"><%= task.errors[:title].to_sentence %></span>
<% end %>
```

目で見るユーザーには色や位置でエラーが分かりますが、スクリーンリーダーのユーザーには、こうした属性がないと伝わりません。

## 25.8 URL は基本不変にする

フォームのやり直しでは、URL は変えません。失敗しても成功しても、ユーザーは同じ画面で操作を続けます。検索（第23章）のように URL に状態を残す必要はありません。`advance` のような URL 操作は、フォームには使わないのが基本です。

## 25.9 テスト

フォームは、次の 3 つを確かめます。

- 無効な入力で、エラーが同じ画面に出る（ページ遷移しない）
- 有効な入力で、成功し、一覧が更新される
- 二重送信が防がれる（送信中にボタンが無効になる）

System Test で、無効入力時にフォームが残りエラーが出ること、有効入力時に一覧へ追加されることを確認します。第16章で書いたテストに、エラー表示の確認（`role="alert"` の存在など）を足すとよいでしょう。

## 25.10 アンチパターン

- <strong>失敗時に 422 ではなく 200 で render する</strong>。Turbo が再描画せず、エラーが画面に出ません（第8章）。最頻出のつまずきです。
- <strong>JavaScript の検証だけにする</strong>。クライアント側の検証は補助です。サーバー検証を省くと、簡単にすり抜けられます。
- <strong>エラー時にフォーカスが迷子になる</strong>。再描画後、フォーカスがどこにあるか分からないと、キーボードやスクリーンリーダーのユーザーが迷います。エラーサマリへフォーカスを移します。

> 第25章では、フォームのエラー表示・送信中・二重送信・a11y を仕上げました。次の第26章では、モーダル・タブ・ドロップダウンを題材に、「サーバーの状態が要るか」で実装が分かれることを学びます。

## 参考資料

- Turbo Drive（Handbook、フォーム送信）: <https://turbo.hotwired.dev/handbook/drive>
- Turbo の属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
- MDN: ARIA（aria-invalid / aria-describedby / role=alert）: <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA>
