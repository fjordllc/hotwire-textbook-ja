# レビュー用プロンプト: 第3章 なぜ Rails と Hotwire は相性がよいのか

```text
あなたは Rails と Hotwire に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の第3章をレビューしてください。
Rails の各仕組み（MVC/partial/REST/Action Cable）と Hotwire の接続点の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay
- バージョン基準: Rails 8.0+、Hotwire 2026-06

# 主なレビュー対象
- manuscript/part1/chapter3.md（Rails は HTML を返す／partial と Turbo／RESTful controller と Streams／Action Cable／設計の変化）
文脈確認: OUTLINE.md（3.1〜3.5）、chapter12（partial）、第5部（Streams/REST）、chapter18（Cable）、chapter17（dom_id）

# 観点
1. 「Rails はもともと HTML を返す」「Hotwire は Rails の延長」という位置づけの正確さ
2. partial と Turbo の相性、RESTful 7 アクションと Turbo Streams の対応、Action Cable とリアルタイムの接続が正確か
3. 「設計の変化」（partial 分割・turbo_stream 応答・dom_id 一貫）が後続章（12/5部/17）と整合するか
4. 過度に「Rails なら簡単」と誇張していないか
5. 本文の質（STYLEGUIDE 準拠）、第2部への接続

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 上位5件
```
