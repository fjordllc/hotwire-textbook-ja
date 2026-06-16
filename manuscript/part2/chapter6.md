# 第6章 Hotwire の標準構成を確認する

## この章のねらい

第5章で作った Relay には、すでに Hotwire 一式が入っています。この章では、それらが「どのファイルにあり、どう読み込まれているか」を把握します。

仕組みを先に押さえておくと、第3部以降で「なぜこの 1 行で Turbo が動くのか」「Stimulus のコントローラはなぜ自動で登録されるのか」と迷わずに済みます。あわせて、本書が JavaScript 構成として importmap を主軸にする理由と、その限界も確認します。

## 6.1 `turbo-rails`

Turbo は `turbo-rails` という gem で入っています。この gem は、2 つのものをまとめて提供します。

1. JavaScript パッケージ `@hotwired/turbo-rails`。これを import すると、Turbo の JavaScript（Turbo Drive / Frames / Streams）が効きます。
2. サーバー側の Rails 用ヘルパー（`turbo_frame_tag` や `turbo_stream` など）と、stream／broadcast の Rails 統合。broadcast 系の API は第18章で扱います。

ブラウザ側は、第5章でも見たとおり `app/javascript/application.js` から読み込まれます。

`app/javascript/application.js`

```javascript
import "@hotwired/turbo-rails"
import "controllers"
```

この `import "@hotwired/turbo-rails"` の 1 行で、Turbo Drive がページ全体に効くようになります。Relay のリンク遷移がフルリロードにならないのは、この行のおかげです。

サーバー側のヘルパーは、第4部以降の view で使います。たとえば `turbo_frame_tag`（第11章）や `turbo_stream`（第15章）は、すべて `turbo-rails` が提供しています。

## 6.2 `stimulus-rails`

Stimulus の本体は `stimulus-rails` という gem で入っています。Stimulus のコントローラは `app/javascript/controllers/` に置きます。

`app/javascript/application.js` の `import "controllers"` が、このディレクトリのコントローラをまとめて読み込んでいます。読み込みの実体は次の 2 ファイルです。

`app/javascript/controllers/application.js`

```javascript
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }
```

`app/javascript/controllers/index.js`

```javascript
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
```

`eagerLoadControllersFrom` が、`controllers/` 配下のコントローラを自動で見つけて登録します。だから、新しいコントローラを作るときは、ファイルを所定の場所に置くだけで動きます。手動での登録は要りません。この仕組みは第6部（Stimulus）で実際に使います。

## 6.3 本書の基本構成: importmap

Relay の JavaScript は importmap で読み込まれています。どのライブラリをどの名前で読み込むかは、`config/importmap.rb` に書かれています。

`config/importmap.rb`

```ruby
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
```

`pin` は「この名前で import したら、このファイルを使う」という対応づけです。`application.js` に書いた `import "@hotwired/turbo-rails"` が、ここの `pin` を通じて実体に結びつきます。`pin_all_from` は、6.2 で見たコントローラ群をまとめて読み込めるようにする指定です。

importmap の状態は、次のコマンドで確認できます。

```bash
bin/importmap json
```

## 6.4 なぜ本書では importmap を主軸にするのか

importmap の最大の特徴は、<strong>JavaScript のビルド工程が要らない</strong>ことです。ES モジュールをブラウザにそのまま配信し、import の名前解決を import map で行います。

本書が importmap を主軸にする理由は次のとおりです。

- Rails 8 の既定構成なので、追加のセットアップが要らない
- npm や bundler 相当のビルドツールを学ぶ必要がなく、Hotwire の本質に集中できる
- 読者の環境差（Node のバージョンなど）の影響を受けにくい

本書は「Rails 学習済みの初級者が Hotwire を理解する」ことが目的です。ビルド構成の習得に寄り道しないために、importmap を選びます。

## 6.5 jsbundling 構成が必要になる場面

一方で、importmap が万能というわけではありません。次のような場合は、jsbundling（esbuild などでビルドする構成）が向きます。

- 多数の npm パッケージや、依存関係の複雑なライブラリを使う
- TypeScript や JSX など、変換（トランスパイル）が必要なコードを書く
- ツリーシェイキングでバンドルサイズを最適化したい

つまり、JavaScript を本格的に書くアプリでは jsbundling が選択肢になります。本書の範囲では importmap で困らないため採用しませんが、「規模が大きくなったら乗り換える選択肢がある」ことは知っておいてください。

## 6.6 外部ライブラリを importmap で扱う方針

Relay でも、第22章で日付ピッカーやチャートといった外部ライブラリを使います。importmap でも、外部ライブラリは扱えます。importmap は、import する名前と取得先を対応づける仕組みなので、公開された ES モジュール（ESM）を pin して使います。

```bash
bin/importmap pin <ライブラリ名>
```

ただし注意点があります。importmap が面倒を見るのは JavaScript だけです。<strong>ライブラリが必要とする CSS は、別途読み込む必要があります。</strong>また、ES モジュールとして配信されていないライブラリは、そのままでは扱いにくい場合があります。

外部ライブラリの初期化と破棄（Turbo の画面差し替えと両立させる方法）は、第22章で具体的に扱います。この章では「importmap でも外部ライブラリを使える。ただし CSS は別」という方針だけ押さえます。

## 6.7 開発中に見るべきログとブラウザ DevTools

Hotwire の挙動を理解・デバッグするには、サーバーのログとブラウザの DevTools を併せて見ます。第8部（デバッグ）の土台になるので、見る場所を先に確認しておきます。

サーバーログ（`bin/rails server` の出力）では、リクエストの形式がわかります。たとえば Turbo Streams のリクエストは、ログに `Processing as TURBO_STREAM` と出ます。これが出ているかどうかで、Turbo Streams として処理されたかを確認できます。

ブラウザの DevTools では、次の 3 つを見ます。

- Network タブ: リクエストの形式とレスポンス。Turbo Streams のレスポンスは MIME タイプが `text/vnd.turbo-stream.html` になります。
- Console タブ: 次の 2 つは別物として見ます。(1) Stimulus の debug ログ。`app/javascript/controllers/application.js` の `application.debug` を `true` にすると、コントローラの接続状況がログに出ます。(2) Turbo イベントの自前ログ。Turbo のイベント（visit や submit など）は自動では出ないので、自分で `addEventListener` を仕込んで出します（仕込み方は第10章・第29章で扱います）。
- Elements タブ: `<turbo-frame>` や `data-controller` 属性が、HTML のどこに付いているか。

これらの見方は、各機能の章で繰り返し使います。いまは「困ったらこの 3 か所を見る」と覚えておけば十分です。

> ここまでで第2部は完了です。Relay の土台ができ、Hotwire 一式がどこにあるかも把握しました。第3部からは、この素の CRUD を Turbo Drive の視点で読み解いていきます。

## 参考資料

- turbo-rails: <https://github.com/hotwired/turbo-rails>
- stimulus-rails: <https://github.com/hotwired/stimulus-rails>
- Rails ガイド「Rails で JavaScript を扱う」: <https://guides.rubyonrails.org/working_with_javascript_in_rails.html>
