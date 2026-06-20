# FBC Press: Hotwire

このリポジトリは、**Hotwire の日本語教科書**の原稿と、Web 書籍として読むための mdBook 設定を管理するものです。

本書は、プログラミングスクール **[FjordBootCamp（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/)** の教材として作成します。

## このプロジェクトは何か

Hotwire の API リファレンスではありません。Rails を学習済みの読者が、次のことを理解し、実際に手を動かして身につけるための教科書です。

- Hotwire が生まれた背景と HTML over the wire という考え方
- Turbo Drive / Turbo Frames / Turbo Streams の役割と使い分け
- Stimulus で「必要な分だけ」JavaScript を書く方法
- Rails アプリを段階的に Hotwire 化する実践的な設計
- Hotwire Native で Web-first なモバイルアプリへ広げる考え方
- React / Vue / SPA との使い分け、アンチパターン、保守とテスト

Tailwind CSS 本よりもハンズオンを多めにし、チーム向けタスク管理アプリ **Relay** を育てながら Hotwire を理解する構成にします。完成版の Relay のコードは、別リポジトリ **[fjordllc/Relay](https://github.com/fjordllc/Relay)** で公開しています（本書の各章と突き合わせて読めます）。

- **対象バージョン:** Hotwire 公式ドキュメントの 2026-06 時点の内容を基準。ハンズオンは Rails 8.0 以上を前提
- **言語・文体:** 日本語・です/ます調
- **想定読者:** Rails の基本、CRUD、REST、フォーム、認証の基礎を学習済みの初級エンジニア
- **JavaScript 構成:** 本編は Rails 標準に近い importmap を主軸にします

## ファイル構成

| ファイル / フォルダ | 役割 |
| --- | --- |
| [`book.toml`](./book.toml) | mdBook の設定。`manuscript/` を原稿ディレクトリとして、ブラウザ閲覧用 HTML を生成します。 |
| [`manuscript/SUMMARY.md`](./manuscript/SUMMARY.md) | mdBook 用の目次。部・章・付録を左ナビとして定義します。 |
| `manuscript/preface.md` | まえがき。対象読者・読み方・バージョン基準をまとめます。 |
| `manuscript/part*/index.md` | 各部の導入ページ。 |
| `manuscript/part*/chapter*.md` | 各章の本文。章ごとに 1 ページへ分割します。 |
| `manuscript/part*/exercises.md` | 各部末のハンズオンまたは演習。 |
| `manuscript/appendix/*.md` | 付録、おわりに。 |
| `manuscript/figures/` | 本文で使う図版。 |
| [`theme/`](./theme/) | mdBook の追加 CSS / JavaScript。日本語テーマと本書固有の上書きを置きます。 |
| [`OUTLINE.md`](./OUTLINE.md) | 詳細目次。全体像や章の狙いを確認できます。 |
| [`STYLEGUIDE.md`](./STYLEGUIDE.md) | 用語の統一・表記・引用・コード例・Markdown 記法のルール。 |
| [`FIGURES.md`](./FIGURES.md) | 図版の内容・配置・alt テキストの仕様。 |
| [`FIGURE_STYLEGUIDE.md`](./FIGURE_STYLEGUIDE.md) | 図版の見た目を揃えるためのデザインルール。 |
| [`REVIEW_NOTES.md`](./REVIEW_NOTES.md) | 執筆・レビュー時に確認する観点のチェックリスト。 |
| [`DEPLOY.md`](./DEPLOY.md) | Cloudflare Pages での公開手順。 |
| `scripts/` | ビルド・図版生成の補助スクリプト（Cloudflare ビルド、未生成図版のレンダリングなど）。 |
| `wrangler.toml` | Cloudflare Pages の設定（ビルド出力先 `book`）。 |

## 本の全体構成

1. **第1部 Hotwire を理解する** - 思想と背景
2. **第2部 ハンズオンの準備** - Rails サンプルアプリの土台
3. **第3部 Turbo Drive** - ページ遷移とフォーム送信
4. **第4部 Turbo Frames** - 画面分割と独立したナビゲーション
5. **第5部 Turbo Streams** - 部分更新とリアルタイム更新
6. **第6部 Stimulus** - 少量の JavaScript で振る舞いを足す
7. **第7部 実務で使う Hotwire UI パターン** - 検索、モーダル、フォーム UX
8. **第8部 Hotwire アプリを保守する** - テスト、デバッグ、性能、セキュリティ
9. **第9部 Hotwire Native** - Web-first なモバイル展開
10. **第10部 Hotwire を選ぶべきか** - アンチパターン、SPA との使い分け、未来

詳細な各節の内容は [`OUTLINE.md`](./OUTLINE.md) を参照してください。

## ブラウザで読む

mdBook をインストール済みなら、次のコマンドでローカルプレビューできます。

```bash
mdbook serve
```

静的 HTML を生成する場合は次を実行します。

```bash
mdbook build
```

生成物は `/book/` に出力されます。これは配信用の成果物なので、リポジトリにはコミットしません。

## Cloudflare Pages で公開する

このリポジトリは Cloudflare Pages で静的配信できます。`mdbook` は Cloudflare の標準イメージに含まれていないため、ビルド時に [`scripts/cloudflare-build.sh`](./scripts/cloudflare-build.sh) が `mdbook` の Linux バイナリを取得してから HTML を生成します。

- Build command: `bash scripts/cloudflare-build.sh`
- Build output directory: `book`
- Root directory: `/`（未設定でも可）

`wrangler.toml` には `pages_build_output_dir = "book"` を定義してあります。`wrangler pages deploy` を使う場合も同じ出力先を使えます。ダッシュボードでの初回設定や更新手順は [`DEPLOY.md`](./DEPLOY.md) を参照してください。

## 品質方針

- 一次情報を最優先します（公式ドキュメント・公式ブログ・GitHub・リリースノート・37signals / Hotwire 関係者の発信）。
- 各章末に「参考資料」セクションを置き、URL を明記します。
- 各概念は **「従来の Rails ではどう書いていたか → なぜ問題か → Hotwire はどう解決するか」** の流れで説明します。
- ハンズオンでは、同じ Rails サンプルアプリを段階的に育てます。

## ライセンス

Copyright (c) 2026 FjordBootCamp

このリポジトリの本文・原稿は [MIT License](./LICENSE) で公開します。
