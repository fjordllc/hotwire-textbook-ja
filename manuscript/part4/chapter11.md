# 第11章 Turbo Frames の基本

## この章のねらい

第3部では、Turbo Drive がリンクやフォーム送信を visit として扱い、ページの `<body>` をまるごと差し替えることを見ました。

しかし実務では、「ページ全体ではなく、一部だけを差し替えたい」場面がよくあります。タスク一覧の 1 行だけを編集フォームに変えたい、詳細パネルだけを切り替えたい、といった場面です。

これを実現するのが Turbo Frames です。この章では、Turbo Frames の基本的な考え方と書き方を学びます。

> この部を貫く軸は「frame は独立した小さな visit 領域である」です。第3部の visit が `<body>` 全体の差し替えなら、Turbo Frame は `<turbo-frame>` 単位の差し替えです。frame 内のリンクやフォームは、ページ全体ではなく frame の中だけを差し替えます。

## 11.1 Turbo Frames とは

第3部で見た visit は、ページ全体が対象でした。リンクをクリックすると、`<body>` がまるごと差し替わります。

これは多くの場面で便利ですが、行きすぎることもあります。たとえば、タスク一覧で 1 件を編集したいだけなのに、ページ全体が切り替わると、ヘッダーもサイドバーも他の行も、すべて描画し直されます。本当は 1 行だけ変えたいのに、です。

Turbo Frames は、ページの一部を `<turbo-frame>` という枠で囲み、その枠を<strong>独立した visit 領域</strong>にします。枠の中のリンクやフォームは、ページ全体ではなく、その枠の中だけを差し替えます。枠の外（ヘッダーやサイドバー）は、まったく動きません。

第3部の visit を「`<body>` 全体の差し替え」とすれば、Turbo Frames は「`<turbo-frame>` 単位の差し替え」です。スコープが違うだけで、起きていることは同じ visit です。

## 11.2 `turbo_frame_tag` と id の一致ルール

frame は、`turbo_frame_tag` ヘルパーで作ります。

```erb
<%= turbo_frame_tag "task_detail" do %>
  <p>ここが frame の中です。</p>
<% end %>
```

これは、次の HTML を生成します。

```html
<turbo-frame id="task_detail">
  <p>ここが frame の中です。</p>
</turbo-frame>
```

ここで、Turbo Frames でもっとも大切なルールを押さえます。<strong>frame は `id` で対応づけられる</strong>、というルールです。

frame の中のリンクをたどると、Turbo はリンク先の HTML を取得し、その中から<strong>同じ `id` を持つ `<turbo-frame>` を探して</strong>、中身を差し替えます。つまり、リンク元のページとリンク先のページの両方に、同じ `id` の frame がなければなりません。

<!-- fig-11-1: Turbo Frame の id 一致。frame 内リンクが、レスポンスから同じ id の turbo-frame だけを抽出して差し替える仕組みと、id 不一致時の Content missing を示す構造図 -->


`id` は手で書く以外に、モデルから作ることもできます。`dom_id` を使うと、レコードに対応した `id` になります。

```erb
<%= turbo_frame_tag dom_id(@task) do %>
  <%= @task.title %>
<% end %>
```

これは `id="task_1"` のような frame を生成します（`dom_id` は第17章でも重要になります）。レコードごとに一意な `id` が要るとき、この書き方が役立ちます。

もし、リンク先に同じ `id` の frame がなかったらどうなるでしょうか。その場合、Turbo はこれをエラーとして扱います。frame には案内メッセージが書き込まれ、例外が投げられて Console にも表示されます。これは Turbo Frames でいちばん多いつまずきです。「frame に意図しない案内メッセージが出た」「Content missing と出る」ときは、まず<strong>両側の `id` が一致しているか</strong>を確認してください（よくあるエラーは付録Eにまとめます）。

## 11.3 frame 内リンク

frame の中にリンクを置くと、そのリンクは frame の中だけを差し替えます。

```erb
<%= turbo_frame_tag "task_detail" do %>
  <%= link_to "次のタスク", task_path(@next_task) %>
<% end %>
```

このリンクをクリックすると、Turbo は `task_path(@next_task)` を取得し、その中の `id="task_detail"` の frame を探して、中身を差し替えます。ページの他の部分は動きません。

ここで 1 つ、第3部との違いがあります。frame 内のリンクで遷移しても、<strong>ブラウザの URL は変わりません</strong>。あくまで frame の中身が変わるだけだからです。これは便利な一方で、「URL と画面の見た目がずれる」という設計上の注意点にもなります。この点は第14章（Frames の失敗パターンと設計判断）で詳しく扱います。

## 11.4 frame 内フォーム

フォームも同じです。frame の中に置いたフォームは、送信しても frame の中だけを差し替えます。

ここで、第8章で学んだ契約がそのまま効きます。成功時はリダイレクト、失敗時は 422 でフォームを再描画、という契約です。frame の中では、その差し替えが frame のスコープで起こります。

たとえば、frame の中の編集フォームを送信したとします。

- 成功すると、Turbo はリダイレクト先を取得し、同じ `id` の frame を探して差し替えます（表示に戻る）
- 失敗すると、422 で返ってきたフォームが、同じ frame の中に差し替わります（エラー付きフォームがその場に出る）

ページ遷移せずに、frame の中だけで「編集 → 保存 → 表示」「編集 → エラー → 再入力」が完結します。この仕組みを使ったインライン編集は、第12章で実際に作ります。

## 11.5 `data-turbo-frame` で別の frame を target する

ここまでは、frame の中のリンクが「自分の frame」を差し替える例でした。しかし、「frame の中のリンクで、別の場所を差し替えたい」こともあります。

そのときは、リンクに `data-turbo-frame` を付けて、対象の frame の `id` を指定します。

```erb
<%= link_to "詳細を開く", task_path(@task), data: { turbo_frame: "task_detail" } %>
```

このリンクは、自分がどこにあっても、`id="task_detail"` の frame を差し替えます。一覧の行から、別の場所にある詳細パネルを更新する、といった使い方ができます。

特別な値として `_top` があります。これを指定すると、frame の中だけでなく、ページ全体を visit します。

```erb
<%= link_to "全体を更新", task_path(@task), data: { turbo_frame: "_top" } %>
```

frame の中のリンクは、既定では frame の中を差し替えます。「このリンクだけはページ全体を遷移させたい」というときに、`_top` を使います。frame に閉じ込められた画面から、通常のページ遷移へ抜け出す手段です。

> 第11章では、frame を「独立した小さな visit 領域」として理解し、`id` の一致というルールを押さえました。次の第12章では、Relay の一覧・詳細・編集フォームを frame 化し、インライン編集を作ります。

## 参考資料

- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
- Turbo Frames リファレンス: <https://turbo.hotwired.dev/reference/frames>
- Turbo の属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
