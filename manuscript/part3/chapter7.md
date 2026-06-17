# 第7章 Turbo Drive の基本

## この章のねらい

第5章で作った Relay は、まだ Hotwire のカスタマイズを何もしていません。それでも、リンクをたどると画面が一瞬で切り替わります。これは Turbo Drive が働いているからです。

この章では、その Turbo Drive の心臓部を理解します。鍵になるのは <strong>visit</strong>（訪問）という考え方です。第3部のあいだ、この言葉を何度も使います。

> この部を貫く軸は「すべては visit である」です。Turbo Drive は、リンクもフォーム送信も visit という同じ処理に揃えます。visit とは「HTML を取得し、`<body>` を差し替え、`<head>` をマージする」ことです。

## 7.1 通常のページ遷移

まず、Turbo がなかった頃のページ遷移を思い出します。

従来の Rails では、リンクをクリックするたびに、ブラウザは次のことをしていました。

1. サーバーに新しいページを要求する
2. 返ってきた HTML で、ページ全体を捨てて作り直す
3. CSS と JavaScript をすべて読み込み直す

この作り直しには、いくつかの問題があります。毎回ページ全体を再構築するため、一瞬白い画面が見えます。スクロール位置は失われます。そして、JavaScript で保持していた状態（開いていたメニューなど）も、すべてリセットされます。

ページの大部分（ヘッダー、サイドバー、CSS、JavaScript）は前のページと同じなのに、毎回まるごと作り直しているわけです。ここに無駄があります。

## 7.2 Turbo Drive の visit と body 差し替え

Turbo Drive は、この無駄をなくします。リンクのクリックを横取りし、ページ全体の作り直しではなく、必要な部分だけの差し替えに変えます。

Turbo Drive がリンク遷移で行うことを、本書では <strong>visit</strong> と呼びます。visit の中身は次のとおりです。

1. リンク先の HTML を、バックグラウンドで取得する（`fetch`）
2. 取得した HTML の `<body>` で、いまの `<body>` を差し替える
3. `<head>` は、まるごと捨てずにマージする（7.3 で扱います）

ページ全体を作り直さないので、白い画面が出ません。`<head>` で読み込み済みの CSS や JavaScript も、読み込み直されません。だから、JavaScript の実行環境を毎回ゼロから立て直さずに済みます。これが、Relay のリンク遷移が速い理由です。

なお、visit には 2 種類あります。リンクのクリックなど新しいページへ進むときの visit（application visit）と、ブラウザの戻る・進むで起きる visit（restoration visit）です。restoration visit はスクロール位置やキャッシュと関わります。<strong>この章では主に application visit を扱い</strong>、restoration visit とキャッシュは第9章で扱います。

なお、速くなるのは「読み込み済みの資産を読み直さない」からであって、`<body>` の中身は差し替わります。開いていたメニューのような body 内の UI 状態は、特別な指定をしない限りリセットされます（状態を保つ方法は第9章で扱います）。

<!-- fig-7-1: Turbo Drive のページ置換。通常遷移は全体を作り直すが、visit は body だけを差し替える（head はマージ） -->

大切なのは、サーバー側は何も特別なことをしていない点です。Relay の controller は、通常どおり HTML を返しているだけです。その HTML をどう適用するか（全体を作り直すか、body だけ差し替えるか）を、ブラウザ側の Turbo Drive が引き受けています。

## 7.3 head のマージと `data-turbo-track="reload"`

visit では `<body>` を差し替えますが、`<head>` は扱いが異なります。`<head>` には CSS や JavaScript の読み込み指定が入っています。これを毎回読み込み直すと、Turbo Drive の利点が消えてしまいます。

そこで Turbo Drive は、`<head>` を捨てずにマージします。新しいページで増えた要素は取り込み、すでに読み込み済みの CSS や JavaScript はそのまま使い続けます。

ただし、困る場面があります。アプリをデプロイして CSS や JavaScript の中身が変わったときです。古い CSS のまま body だけ差し替え続けると、見た目が壊れます。

これを防ぐのが `data-turbo-track="reload"` です。Rails の既定レイアウトでは、CSS の読み込みにこの指定が付いています。

`app/views/layouts/application.html.erb`

```erb
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<%= javascript_importmap_tags %>
```

ここで追跡対象になるのは、`data-turbo-track="reload"` を付けた要素です。上の例では、`stylesheet_link_tag` に自分でこの属性を指定した CSS がそれにあたります。Turbo Drive は、visit のたびに追跡対象の新旧を比べ、内容が変わっていたら（＝デプロイで CSS が更新されていたら）、body だけの差し替えをやめて、ページ全体を読み込み直します。

2 行目の `javascript_importmap_tags` は、import map を使って JavaScript を読み込むためのタグをまとめて生成するヘルパーです（第6章）。追跡したい資産には、このように `data-turbo-track="reload"` を付けて監視対象にする、と理解しておけば十分です。

つまり、普段は visit で速く、アセットが変わったときだけ安全にフルリロードする、という使い分けが自動で行われます。

## 7.4 progress bar

visit では、リンク先の HTML をバックグラウンドで取得します。回線が遅いと、取得に時間がかかることがあります。その間、画面は前のページのままなので、ユーザーには「クリックが効いたのか」がわかりません。

Turbo Drive は、これに備えて progress bar（進捗バー）を用意しています。visit に時間がかかると、画面上部に細いバーが表示されます。

ここで 1 つ知っておくべき仕様があります。progress bar は、visit を始めてすぐには出ません。<strong>既定では 500 ミリ秒経ってから</strong>表示されます。多くの遷移は 500 ミリ秒以内に終わるため、その場合はバーが出ません。一瞬で終わる遷移にまでバーを出すと、かえってちらついて見えるからです。

この遅延時間は変更できますが、まずは「すぐに終わる遷移ではバーは出ない」という既定の動きを理解しておけば十分です。

## 7.5 visit を無効化する

Turbo Drive は、すべてのリンクとフォームに自動で効きます。ほとんどの場面ではそれで問題ありませんが、ときには visit させたくないリンクもあります。たとえば、別のサーバーが返すファイルのダウンロードや、Turbo と相性の悪い外部ページへの遷移です。

そうしたリンクには、`data-turbo="false"` を付けます。

```erb
<%= link_to "PDF をダウンロード", report_path(format: :pdf), data: { turbo: false } %>
```

`data-turbo="false"` が付いたリンクは、Turbo Drive が横取りせず、従来どおりのページ遷移になります。

この指定は、囲んだ範囲にもまとめて効かせられます。あるコンテナ全体で visit を切り、その中の一部だけ visit を戻したい場合は、内側で `data-turbo="true"` を指定します。

無効化はあくまで例外的な手段です。Turbo Drive を切るほど、Hotwire を使う意味は薄れます。「ここは visit させない方がよい」とはっきり言える場面に限って使ってください。

> 第7章では、Turbo Drive のリンク遷移を visit として理解しました。次の第8章では、フォーム送信も同じ visit であること、そして成功と失敗で controller が返すべきものが決まっていることを見ます。

## 参考資料

- Turbo Drive（Handbook）: <https://turbo.hotwired.dev/handbook/drive>
- Turbo の属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
