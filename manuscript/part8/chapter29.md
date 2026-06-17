# 第29章 デバッグとイベント観察

## この章のねらい

Hotwire のアプリがうまく動かないとき、「どこで差し替えが止まったのか」を切り分けられると、解決が早くなります。この章では、その<strong>観察の道具</strong>を体系化します。

闇雲にコードを直す前に、観察します。順番は、Network → Turbo のイベント → Stimulus の接続 → Frame / Stream の target → morph、です。上から順に見れば、たいていの不具合は場所を特定できます。第28章のテストでは捉えきれない不具合を、ここで追います。

## 29.1 Network タブで見るべきもの

最初に見るのは、ブラウザの DevTools の Network タブです。リクエストとレスポンスが、意図どおりかを確かめます。

- <strong>リクエストのメソッド</strong>。GET か、POST / PATCH / DELETE か。
- <strong>`Accept` ヘッダー</strong>。Turbo Streams を期待する送信には、`text/vnd.turbo-stream.html` が含まれているか（第15章）。
- <strong>レスポンスのステータス</strong>。成功は redirect（303 など）、失敗は 422 か（第8章）。ここがずれていると、フォームが期待どおり動きません。
- <strong>レスポンスの中身</strong>。`<turbo-stream>` の命令や、`<turbo-frame>` の HTML が、実際に返ってきているか。

「サーバーは何を返したか」が分かれば、問題がサーバー側かブラウザ側か、切り分けられます。

## 29.2 Turbo イベントをログに出す

次に、Turbo が何をしたかを見ます。第10章で見たとおり、Turbo のイベントは自分で購読しないと表に出ません。デバッグ時は、主なイベントをログに出します。

```javascript
;["turbo:visit", "turbo:submit-start", "turbo:submit-end", "turbo:before-render", "turbo:render", "turbo:frame-load"].forEach((name) => {
  document.addEventListener(name, (event) => console.log(name, event.detail))
})
```

これで、visit が始まったか、送信が成功したか、frame が読み込まれたか、といった節目が Console に出ます。frame の描画を細かく見たいときは、`turbo:frame-render` も加えます。「イベントが出ない＝そもそも Turbo が動いていない」と分かります。

## 29.3 Stimulus controller の接続を確認する

Stimulus が動かないときは、controller が結びついているかを確かめます。第6章で見たとおり、`application.debug` を `true` にすると、controller の接続・切断がログに出ます。

```javascript
// app/javascript/controllers/application.js
application.debug = true
```

接続のログが出なければ、`data-controller` の名前とファイル名がずれている（第19章）、ファイルの置き場所が違う、といった原因が疑えます。`window.Stimulus` から、登録された controller を確認することもできます。

## 29.4 Frame / Stream の target を確認する

Turbo Frames や Turbo Streams で「更新されない」ときは、たいてい `id` の不一致です（第11章・第17章）。

- Frame なら、リンク先のレスポンスに、同じ `id` の `<turbo-frame>` があるか。なければ、frame に案内メッセージが出て例外になります（第11章）。
- Stream なら、`target` が指す `id` の要素が、画面に存在するか。存在しない `id` を指すと、その命令は静かに何も起こしません。

DevTools の Elements タブで、`<turbo-frame>` の `id` や、stream の `target` が指す要素を探します。`dom_id` を使っていれば、表示側と命令側の `id` は揃うはずです（第17章）。手書きの `id` がずれていないかを疑います。

## 29.5 morphing の差分を疑う

morph（第9章）を使っているのに、思ったとおりに更新されない・要素が消えない・状態が残る、というときは、morph の差分を疑います。

morph には専用のイベントがあります（第10章）。

```javascript
document.addEventListener("turbo:before-morph-element", (event) => console.log("morph", event.target))
```

`turbo:before-morph-element` を観察すると、どの要素が morph の対象になっているかが分かります。`data-turbo-permanent` で保持しているはずの要素が morph されていないか、逆に保持したい要素が差し替わっていないか、を確かめられます。

## 29.6 フォーカス崩れ・読み上げ崩れを切り分ける

部分更新の後で、フォーカスが飛ぶ・読み上げが起きない、といった不具合もあります。アクセシビリティの<strong>方針</strong>は第7部で扱いました。この章では、その<strong>原因の切り分け</strong>に徹します。

- フォーカスが今どこにあるかは、Console で `document.activeElement` を見れば分かります。差し替えの前後でフォーカスがどう動いたかを追えます。
- 読み上げ領域（`aria-live`）が効いているかは、DevTools のアクセシビリティツリーで、その要素の role や live 設定を確認します。

「どこで差し替えが起きて、その結果フォーカスや読み上げがどうなったか」を、29.2 のイベントログと合わせて追うと、原因の場所が絞れます。

## 29.7 よくあるエラーの読み方

最後に、頻出のエラーです。多くは、ここまでの観察で原因にたどり着けます。

- 「Content missing」「frame に案内メッセージ」… Frame の `id` 不一致（29.4）。
- フォームを送ったのに何も起きない … 失敗を 200 で返している（29.1 でステータスを確認）。
- Stimulus が動かない … controller の接続ログが出ない（29.3）。
- 更新の命令が効かない … stream の `target` が存在しない（29.4）。

代表的なエラーと対処は、付録Eにまとめます。困ったら、まず Network、次に Turbo イベント、Stimulus、target、morph。この順で見れば、たいていの不具合は場所が分かります。

> 第29章では、不具合の場所を切り分ける観察の道具を整えました。次の第30章では、Hotwire の体感速度を損なう、Rails 側のパフォーマンス問題（とくに N+1）を扱います。

## 参考資料

- Turbo のイベントリファレンス: <https://turbo.hotwired.dev/reference/events>
- Stimulus リファレンス（Lifecycle Callbacks）: <https://stimulus.hotwired.dev/reference/lifecycle-callbacks>
- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
