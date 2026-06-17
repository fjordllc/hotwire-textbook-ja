# 第10章 Turbo Drive のイベントと制御

## この章のねらい

ここまでで、Turbo Drive が visit でページを差し替える様子を見てきました。多くの場合、Turbo は自動で動くので、こちらから何かする必要はありません。

しかし、ときには visit の途中に割り込みたい場面があります。「削除の前に確認したい」「遷移に時間がかかるあいだローディングを出したい」「何が起きているかログで追いたい」といった場面です。

この章では、そのために使う Turbo の<strong>イベント</strong>と、いくつかの制御方法を見ます。これは第3部の締めであり、第8部（デバッグ）の入口にもなります。

## 10.1 visit ライフサイクルの主要イベント

visit は、一瞬で終わるように見えて、内部ではいくつかの段階を踏んでいます。Turbo は、その節目ごとにイベントを発火します。リンクのクリックから画面表示までの主な流れは、次のとおりです。

- `turbo:click` — Turbo が有効なリンクをクリックした
- `turbo:before-visit` — visit を始める直前
- `turbo:visit` — visit を始めた
- `turbo:before-render` — 新しい body を描画する直前
- `turbo:render` — 描画した
- `turbo:load` — ページの読み込みが完了した（初回と、各 visit のあと）

これらのイベントは、すべて `document` で発火します。必要な段階に合わせてイベントを購読すれば、その瞬間に処理を差し込めます。

ここで思い出してほしいのが、第6章で触れた点です。Turbo のイベントは、自分で購読しない限り、何も表に出てきません。次の節から、実際に購読して制御してみます。

## 10.2 submit 前後の制御

フォーム送信にも、専用のイベントがあります。送信の前後で処理を挟みたいときに使います。

- `turbo:submit-start` — フォーム送信が始まった
- `turbo:submit-end` — フォーム送信が終わった（成功・失敗の結果を含む）

たとえば、送信中は送信ボタンを押せないようにして、二重送信を防ぎたいとします。`turbo:submit-start` でボタンを無効にし、`turbo:submit-end` で戻す、という形が考えられます。

なお、Turbo は送信中のボタンを自動で無効にする機能も持っています。二重送信の防止や、送信中の表示の作り込みは、第25章（フォーム UX）でまとめて扱います。ここでは「送信の前後にイベントがある」ことを押さえておけば十分です。

## 10.3 visit の制御

visit そのものを止めたい場面もあります。たとえば「入力中の内容が保存されていないので、ページを離れる前に確認したい」といった場合です。

`turbo:before-visit` は、visit を始める直前に発火します。このイベントで `event.preventDefault()` を呼ぶと、visit を中断できます。

逆に、こちらから visit を起こすこともできます。`Turbo.visit()` を使います。

```javascript
Turbo.visit("/projects", { action: "replace" })
```

`action: "replace"` を付けると、履歴に新しく積まず、いまの履歴を置き換えて遷移します。プログラムから画面を切り替えたいときに使います。

## 10.4 確認ダイアログとローディング表示

実務でよく使う制御は、わざわざイベントを書かなくても、属性だけで実現できます。

削除の前に確認したいときは、`data-turbo-confirm` を使います。Relay のプロジェクト削除に付けてみます。

```erb
<%= button_to "削除", project_path(project),
      method: :delete,
      data: { turbo_confirm: "本当に削除しますか?" } %>
```

`data-turbo-confirm` が付いたリンクやボタンを操作すると、Turbo はまず確認ダイアログを出します。ユーザーが承認したときだけ、送信に進みます。既定ではブラウザの確認ダイアログ（`window.confirm`）が使われます。

ローディング表示については、第7章で見た progress bar が、遅い visit のときに自動で出ます。多くの場合はこれで十分です。これ以上の作り込み（特定の領域だけにスピナーを出すなど）は、10.2 のイベントを使って行います。

## 10.5 デバッグ用イベントログ

Turbo の動きがわからなくなったときは、イベントをログに出すのが有効です。第6章で触れたとおり、Turbo のイベントは自分で購読しないと表に出ません。逆に言えば、購読すれば何でも観察できます。

主なイベントをまとめてログに出す、小さなコードを置いてみます。

```javascript
;["turbo:click", "turbo:before-visit", "turbo:visit", "turbo:before-render", "turbo:render", "turbo:load"].forEach((name) => {
  document.addEventListener(name, (event) => {
    console.log(name, event.detail)
  })
})
```

これで、リンクをたどるたびに、どのイベントがどの順で発火しているかが Console に出ます。`event.detail` には、visit 先の URL などの情報が入っています。

このログは、第29章（デバッグとイベント観察）で本格的に使います。ここでは「困ったらイベントを観察できる」と知っておけば十分です。

## 10.6 `turbo:morph` 系イベントを観察する

第9章で見た morph にも、専用のイベントがあります。

- `turbo:before-morph-element` — ある要素を morph する直前（各要素ごと）
- `turbo:morph` — morph が終わった

`turbo:before-morph-element` は要素ごとに発火し、`event.preventDefault()` でその要素の morph をスキップできます。外部ライブラリが管理している要素など、「ここは Turbo に触らせたくない」という部分を守るのに使えます。

morph が思ったとおりに当たらないときは、これらのイベントを観察すると、どの要素がどう書き換わっているかを追えます。

> 第3部はここまでです。Turbo Drive を「visit」という 1 つの軸で読み解きました。リンクとフォームの visit、成功と失敗の契約、キャッシュとプレビュー、morph、そしてイベントによる制御です。次の第4部では、ページの一部を独立した visit 領域として扱う Turbo Frames に進みます。

## 参考資料

- Turbo のイベントリファレンス: <https://turbo.hotwired.dev/reference/events>
- Turbo Drive（Handbook）: <https://turbo.hotwired.dev/handbook/drive>
- Page Refreshes と morphing（Handbook）: <https://turbo.hotwired.dev/handbook/page_refreshes>
