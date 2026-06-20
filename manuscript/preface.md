# はじめに

> **FBC Press: Hotwire**
> ― HTML over the wire という設計思想から理解する

本書は、プログラミングスクール **[FjordBootCamp（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/)** の教材として作成された、Hotwire の教科書です。Rails の基本を学習済みの読者に向けています。

Hotwire は、ブラウザで動く JavaScript アプリケーションを大きく作る代わりに、サーバーで生成した HTML を活かして、現代的な操作感を実現するための考え方とツール群です。

本書では、思想や生まれた背景を扱いながら、Tailwind CSS 本よりもハンズオンを多くします。題材は、チーム向けタスク管理アプリ <strong>Relay</strong>です。この 1 つのアプリを最初から最後まで育てながら、通常の CRUD から Turbo Drive、Turbo Frames、Turbo Streams、Stimulus、Hotwire Native へ段階的に広げていきます。

## 想定読者

- Rails の MVC、CRUD、REST、フォームを学習済みである
- ERB と partial を使ったことがある
- JavaScript の基礎文法を読める
- SPA フレームワークを本格的に使った経験は必須ではない

## 読み方

第1部では、Hotwire の思想と背景を説明します。[第2部](part2/index.md)以降は、サンプルアプリを育てながら手を動かします。

各部末のハンズオンは、その部で学んだ概念を実際の Rails アプリに適用するための章です。読み飛ばさずに進めると、最後に実務的な Hotwire アプリの形が残る構成にします。[第3部](part3/index.md) 以降は、1 つのアプリを段階的に Hotwire 化していきます。

## バージョン基準

本書は 2026年6月時点の Hotwire 公式ドキュメントを基準にします。Turbo、Stimulus、Hotwire Native、Rails のバージョンによって挙動が変わる箇所は、章ごとに明記します。
