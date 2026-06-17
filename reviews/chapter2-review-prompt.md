# レビュー用プロンプト: 第2章 HTML over the wire という考え方

```text
あなたは Rails と Hotwire、Web フロントエンドの歴史に詳しいシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の第2章をレビューしてください。
歴史的経緯の正確さと、SPA への公平さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- バージョン基準: Hotwire 2026-06

# 主なレビュー対象
- manuscript/part1/chapter2.md（画面更新の歴史／Ajax と JSON API／SPA が解決したこと・増やしたこと／HTML を送る再評価／Hotwire が向くアプリ）
文脈確認: OUTLINE.md（2.1〜2.5）、第10部（使い分け）

# 観点
1. 歴史の記述（全ページ再読み込み→Ajax→JSON API→SPA）が正確で、単純化しすぎていないか
2. 「SPA が増やした複雑さ」の記述が公平か（SPA を不当に貶めていないか）
3. HTML over the wire の利点（JS 最小・状態サーバー・検証一本化）の主張が誇張でないか
4. Hotwire が向く/向かないアプリの線引きが妥当で、第10部と整合するか
5. 本文の質（STYLEGUIDE 準拠）、第3章への接続

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 上位5件
```
