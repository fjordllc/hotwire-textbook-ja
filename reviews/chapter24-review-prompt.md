# レビュー用プロンプト: 第24章 ページネーションと無限スクロール

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第24章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、ページネーションと無限スクロールの章をレビューしてください。
コードの実動と、置換/追記/検知の道具の割り当ての妥当性を最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。Task はフラット scaffold、_task partial あり、#tasks 一覧コンテナ
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap
- 第7部の3つの問い: サーバー状態 / 1か所か複数か / きっかけは誰か

# 主なレビュー対象
- manuscript/part7/chapter24.md（3段階の完成像→道具の割当→通常ページング→Frame内+advance→もっと読む(Streams append)→IntersectionObserver→ボタンを残す→URL/スクロール→テスト→アンチパターン）
文脈確認: chapter11/14（frame, advance）、chapter15（GET の data-turbo-stream opt-in）、chapter22（observer の disconnect）、OUTLINE.md（24.1〜24.10）

# 重点的に見てほしい観点
1. 手動ページネーションの controller（offset/limit、@next_page の判定、scope.count）が正しく動くか。PER_PAGE 定数の置き場所、order(:id) の必要性
2. Frame 内ページング + data-turbo-action="advance" で URL が ?page= に反映される説明の正否
3. もっと読む（Streams append）。link_to に data: { turbo_stream: true } で GET でも stream を受ける（第15章 opt-in）点、index.turbo_stream.erb の append collection と update "pagination"、最終ページでボタンが消える流れ。respond_to の format.turbo_stream
4. turbo_stream.append "tasks", partial: "tasks/task", collection: @tasks の構文。append 先 #tasks の整合
5. IntersectionObserver の Stimulus 化（connect で observe、isIntersecting で button.click、disconnect で解除）。button target の指定
6. ボタンを土台に残す a11y 論、URL/スクロール位置のトレードオフが妥当か
7. テスト観点（重複なし・終端）とアンチパターンが実務的か
8. 本文の質（STYLEGUIDE 準拠）、第25章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）でランク、file:line と修正案、推測は「要確認」
- 最後に第25章の執筆前に直すべき上位5件
```
