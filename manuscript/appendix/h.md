# 付録H Hotwire Native ハンズオン（実機ビルド手順）

第9部では、Hotwire Native の考え方を学びました。この付録では、実機でビルドして Relay を表示するまでの手順を、流れに沿って案内します。

実機ビルドには、ネイティブの開発環境が必要です。具体的なコマンドや画面は、Xcode / Android Studio や Hotwire Native のバージョンによって変わります。<strong>本付録は流れを示すもの</strong>で、最新の正確な手順は、必ず公式ドキュメントで確認してください。

- Hotwire Native: <https://native.hotwired.dev/>

## 前提

- iOS は Xcode、Android は Android Studio が要ります。
- Relay（本書の Rails アプリ）が起動していて、実機・シミュレータからアクセスできること。シミュレータからは、開発マシンの IP やホスト名で Rails に届く必要があります。
- Web 側（Relay）が、モバイルの画面幅でも使えること（レスポンシブ。第32章）。

## 手順の流れ

### 1. ネイティブプロジェクトを用意する

- iOS … Xcode で新規アプリを作り、Hotwire Native の iOS ライブラリ（Swift）を追加します。
- Android … Android Studio で新規アプリを作り、Hotwire Native の Android ライブラリ（Kotlin）を追加します。

ライブラリの追加方法（Swift Package / Gradle の指定）は、公式ドキュメントの手順に従います。

### 2. Relay の URL を指す

ネイティブアプリの開始 URL を、Relay のトップ（または一覧）に設定します。これだけで、WebView に Relay の Web 画面が表示され、ネイティブのナビゲーションの中で動き始めます（第32章）。まずは、ここまでで「Web がアプリの中で動く」ことを確認します。

### 3. Path Configuration を置く

URL ごとの見せ方を、Path Configuration（第33章）で指定します。アプリに同梱するか、サーバーから配信します。たとえば、`/tasks/new` をモーダルで出すルールを書きます。正確なプロパティ名と値は、公式ドキュメントで確認します。

### 4. Bridge Components を足す（任意）

ネイティブの定位置に部品を置きたい場合、Bridge Components（第34章）を使います。Web 側にブリッジ用の Stimulus controller を、ネイティブ側に対応する component を用意します。ここで大切なのは、ブラウザでも壊れないよう、Web 側にフォールバック（通常の送信ボタンなど）を残すことです（第34章）。

### 5. Native Screens と認証（任意）

ログインなどをネイティブ画面にする場合（第35章）、ネイティブで認証した結果を WebView のセッションへ受け渡します。cookie やトークンの受け渡しは、安全に設計します（第31章）。具体的な受け渡しの実装は、公式ドキュメントの例を参照します。

## 配布の注意

ネイティブ部分（native shell・ネイティブ画面・Bridge Components）を変えたら、アプリをビルドし直し、ストアで配信（審査）します。Web 画面の更新はサーバーで即反映できますが、ネイティブ部分はストアを通します（第32章・第35章）。更新サイクルの違いを踏まえ、ネイティブ部分は最小限にします。

## まとめ

「Relay の URL を指すだけで Web が動く」ところから始め、必要に応じて Path Configuration・Bridge Components・Native Screens を足す。この順で進めれば、Web-first のまま、無理なくモバイルへ広げられます。詰まったら、考え方は第9部に、最新の手順は公式ドキュメントに戻ってください。
