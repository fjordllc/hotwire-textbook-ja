# デプロイ手順（Cloudflare Pages）

本書は mdBook で生成する静的サイトです。Cloudflare Pages の Git 連携でビルド・公開します。
ビルド環境に mdBook は入っていないため、[scripts/cloudflare-build.sh](./scripts/cloudflare-build.sh) が
公式バイナリを取得してから `mdbook build` を実行します。

## 初回セットアップ

1. [Cloudflare ダッシュボード](https://dash.cloudflare.com/) → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**
2. GitHub の `fjordllc/hotwire-textbook-ja` リポジトリを選択
   （fjordllc Organization へのアクセス許可が必要）
3. ビルド設定を以下のように入力する:

   | 項目 | 値 |
   | --- | --- |
   | Production branch | `main` |
   | Framework preset | `None` |
   | Build command | `bash scripts/cloudflare-build.sh` |
   | Build output directory | `book` |

4. **Save and Deploy** を押す

数十秒から 1 分ほどでビルドが完了し、`https://<プロジェクト名>.pages.dev` で公開されます。

## 以降の更新

`main` ブランチへ push すると自動で再ビルド・再デプロイされます。
Pull Request にはプレビュー URL が自動で付きます。

## mdBook のバージョンを上げるとき

1. ローカルで新しい mdBook を入れて `mdbook build` が通ることを確認
2. [scripts/cloudflare-build.sh](./scripts/cloudflare-build.sh) の `MDBOOK_VERSION` を更新
3. commit / push

## ローカルでの確認

```sh
mdbook serve --open
mdbook build
```
