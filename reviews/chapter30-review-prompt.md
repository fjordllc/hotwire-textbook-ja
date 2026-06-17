# レビュー用プロンプト: 第30章 パフォーマンスと N+1

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第30章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、パフォーマンスと N+1 の章をレビューしてください。
Rails の最適化手法の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。Task は assignee(User,optional) / tags(through taggings) / comments を持つ。一覧は _task partial、Streams/broadcast あり
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap
- 第8部の軸: Hotwire は遅い Rails を隠さない

# 主なレビュー対象
- manuscript/part8/chapter30.md（隠さない→partial コスト→N+1 と includes→broadcast 回数→fragment cache→大きすぎる Streams→測ってから直す）
文脈確認: chapter12/17/18/24/9、OUTLINE.md（30.1〜30.7）

# 重点的に見てほしい観点
1. N+1 と includes。Task.includes(:assignee, :tags) で N+1 解消、tags は through 関連でも includes が効くか。comments 件数は counter_cache か先読み、という記述の妥当性
2. コレクション描画（render @tasks）が 1件ずつ render より最適化される、という記述の正否
3. broadcast の partial でも N+1 が起きる、重い配信は *_later、大量更新は broadcast refresh、という整理（第18/9章整合）
4. fragment cache。cache task のキー（更新時刻含む）、partial 共通化との相乗、Russian doll の言及要否
5. 大きすぎる Streams をページネーションで分ける（第24章）
6. 測定。サーバーログでクエリ数、Bullet で N+1 検出、rack-mini-profiler。推測で includes を撒かない、という原則
7. 本文の質（STYLEGUIDE 準拠）、第31章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第31章の執筆前に直すべき上位5件
```
