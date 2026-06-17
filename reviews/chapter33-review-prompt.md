# レビュー用プロンプト: 第33章 Path Configuration

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第33章を書き起こした時点のものです。

```text
あなたは Rails / Hotwire Native に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、Path Configuration の章をレビューしてください。
Path Configuration の JSON 構造・プロパティ名の正確さを最優先で見てください（不確かなら「要確認」と明示）。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。/tasks/new などの URL。第26章でモーダルの URL 設計、第14章で URL と画面状態
- バージョン基準: Hotwire 2026-06。詳細は付録H

# 主なレビュー対象
- manuscript/part9/chapter33.md（役割／URL pattern（正規表現）／presentation（modal等）／rules の管理（サーバー配信）／Web ルーティングとの関係）
文脈確認: chapter32（native shell）、chapter14/26、OUTLINE.md（33.1〜33.5）

# 重点的に見てほしい観点（事実確認を最優先）
1. Path Configuration が JSON で settings + rules（patterns + properties）という構造である点の正確さ
2. patterns がパスに対する正規表現である点（"/tasks/\\d+/edit" のような書き方）
3. presentation/context の指定。"context": "modal" でモーダル提示、という記述が現行 Hotwire Native のプロパティ名・値として正しいか（本文は「正確なキー名はバージョンで異なるので公式/付録Hで確認」と逃がしている。この逃がし方で十分か、それとも正しいキー名を today の docs で確定して載せるべきか）
4. rules をアプリ同梱／サーバー配信でき、配信ならストア無しで更新できる（ただしルールの更新に限る）という記述の正否
5. Web の URL 設計が Path Configuration の土台になる、第26章のディープリンク判断と呼応する、という整理の妥当性
6. 本文の質（STYLEGUIDE 準拠）、第34章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在（native.hotwired.dev）、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第34章の執筆前に直すべき上位5件
```
