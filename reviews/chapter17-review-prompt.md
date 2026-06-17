# レビュー用プロンプト: 第17章 複数箇所を同時に更新する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第17章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Turbo Streams で複数箇所を同時更新する設計章をレビューしてください。
コードの実動と、id/dom_id の整合、設計判断の妥当性を見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。_task は turbo_frame_tag task（id=task_1）。index は #flash / #new_task_form / #tasks 構造（第16章）。Turbo 前提・html はフォールバック
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第5部の軸: 「Streams は差し替え命令の入った HTML を送る」

# 主なレビュー対象
- manuscript/part5/chapter17.md（本文。複数 stream、カウンター更新、空状態、partial 共通化、dom_id と id 設計、aria-live の入口）
文脈確認のため: chapter16.md（CRUD stream）、chapter12.md（_task/frame）、chapter15.md（8 アクション）、OUTLINE.md（17.1〜17.6）、STYLEGUIDE.md

# 重点的に見てほしい観点
1. コードの実動。要検証:
   - destroy.turbo_stream.erb の remove + update "task_count" + update "flash" の並べ方
   - turbo_stream.update "task_count" do ... end のブロック構文
   - 空状態対応で turbo_stream.replace "tasks", partial: "tasks/tasks", locals: { tasks: } が _tasks partial（root が <div id="tasks">）を置き換える設計の正否
   - _tasks partial の中の render tasks（コレクション描画）が _task を呼ぶこと
2. 設計判断の妥当性。「remove は精密だが空状態を別に面倒見る／領域ごと replace は重いが空状態を自然に扱える」というトレードオフの説明は妥当か。第16章で destroy=remove としたものを、本章で replace 領域に切り替える流れに矛盾や説明不足がないか
3. dom_id の説明が正確か。要検証:
   - dom_id(task) => "task_1"、dom_id(task, :edit) => "edit_task_1"、dom_id(Task.new) => "new_task"
   - turbo_frame_tag task の id と turbo_stream.replace @task の target が dom_id で一致するという説明
   - id を手書きしないという指針
4. カウンターの件数の出し方（Task.count と「表示中の一覧に合わせる」注記）が誤解を生まないか
5. a11y の入口。role="status" が aria-live="polite" を含む、という記述の正否。第7部へ送る切り分けが妥当か
6. 本文の質（STYLEGUIDE 準拠）。第18章（Action Cable broadcast）への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメント / API の URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか
- Turbo Streams の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 17.3）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第18章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
