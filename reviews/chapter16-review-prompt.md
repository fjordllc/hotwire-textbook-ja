# レビュー用プロンプト: 第16章 create / update / destroy を Stream 化する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第16章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Turbo Streams で CRUD を実装する章をレビューしてください。
コントローラ・ビュー・テストがそのまま動くかを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。Task はフラット scaffold。_task は turbo_frame_tag task（id=task_1）で囲む（第12章）。第8章で 303/422 契約、第15章で stream の仕組み（8 アクション・format.turbo_stream・MIME）を学習済み
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸

# 主なレビュー対象
- manuscript/part5/chapter16.md（本文。create→prepend、update→replace、destroy→remove、flash 更新、エラー時 422 でフォーム差し替え、System Test）
文脈確認のため: chapter15.md（stream 基本）、chapter12.md（_task/frame）、chapter8.md（422）、OUTLINE.md（16.1〜16.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（コードの実動を最優先で検証）
1. turbo_stream ヘルパーの使い方が正しいか。要検証:
   - turbo_stream.prepend "tasks", @task が _task partial を描画して #tasks 先頭へ追加する
   - turbo_stream.update "new_task_form" do ... end のブロック構文
   - turbo_stream.replace @task が dom_id(@task)=task_1 を target に _task を描いて要素ごと差し替える（_task が turbo_frame_tag の場合の id 整合）
   - turbo_stream.remove @task が task_1 を削除する
   - turbo_stream.update "flash", partial: "layouts/flash" の表記
2. respond_to の完全形が正しいか。成功=format.turbo_stream（create.turbo_stream.erb）、失敗=render turbo_stream: ..., status: :unprocessable_entity。Turbo が 422 でも turbo-stream 応答を命令として処理する、という記述の正否
3. flash.now を使う理由（ページ遷移しないため）が正しいか。layouts/_flash partial と id="flash" の前提
4. index の構造（#flash, #new_task_form, #tasks）が以降の stream の target と整合しているか。第12章の _task（frame id=task_1）と replace/remove の target が一致するか
5. System Test。tasks_path（フラット）、fill_in "Title"/"Project"、within "#tasks"/"#new_task_form"/"##{dom_id(task)}"、削除リンク "削除"、エラー文言 "prohibited" が scaffold/実装と整合するか
6. 第12章（frame でのインライン編集）と第16章（stream での update）の関係に矛盾がないか（update のレスポンスが stream のとき frame 抽出ではなく stream 処理になる点）
7. 本文の質（STYLEGUIDE 準拠）。第17章（複数箇所同時更新の深掘り）への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか（特にヘルパー・respond_to・テスト）
- Turbo Streams の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 16.5）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントや実際の挙動で確認すべき箇所は「要確認」と明示する
- 最後に、第17章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
