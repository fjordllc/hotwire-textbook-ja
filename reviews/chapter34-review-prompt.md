# レビュー用プロンプト: 第34章 Bridge Components

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第34章を書き起こした時点のものです。

```text
あなたは Rails / Hotwire Native / Stimulus に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、Bridge Components の章をレビューしてください。
Bridge Components が Stimulus の上に乗る点と、Web/ネイティブの対応の正確さを最優先で見てください（不確かは「要確認」）。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。第6部で Stimulus（controller/action/target/values）
- バージョン基準: Hotwire 2026-06。詳細・基底クラスは付録H
- 第9部: Web-first、native shell（第32章）、Path Configuration（第33章）

# 主なレビュー対象
- manuscript/part9/chapter34.md（Bridge Components とは／Web 側マークアップ(data-controller)／ネイティブ側 component／メッセージ送受信／使いすぎを避ける）
文脈確認: chapter19-21（Stimulus）、chapter32（iOS/Android）、OUTLINE.md（34.1〜34.5）

# 重点的に見てほしい観点（事実確認を最優先）
1. Bridge Components が Stimulus controller の延長（ブリッジ用に拡張した controller）である、という記述の正確さ。基底クラス名等は付録H/公式に逃がしているが、その逃がし方で十分か
2. Web 側 data-controller の宣言と、ネイティブ側 component が名前で対応づく、という説明の正否
3. Web→ネイティブ／ネイティブ→Web のメッセージ往復（指示と出来事）、Web 側受信はブリッジ controller のメソッド、という整理
4. 「送信ボタンをナビゲーションバーに出す」例が、Bridge Components の典型例として妥当か
5. 使いすぎを避ける判断（Web で足りるなら橋を架けない）が第32章と整合するか
6. 本文の質（STYLEGUIDE 準拠）、第35章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在（native.hotwired.dev）、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第35章の執筆前に直すべき上位5件
```
