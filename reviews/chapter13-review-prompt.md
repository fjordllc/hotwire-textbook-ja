# レビュー用プロンプト: 第13章 遅延読み込みと独立したナビゲーション

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第13章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Turbo Frames の遅延読み込みと画面分割の章をレビューしてください。
手順とコードがそのまま動くか、frame の id 一致が全体で破綻していないかを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。resources :projects と resources :tasks（フラット）。第12章で _task を turbo_frame_tag task（id=task_1）で囲み、show は render @task にしていた
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第4部の軸: 「frame は独立した小さな visit 領域」。第11章で id 一致、第12章でインライン編集を学習済み

# 主なレビュー対象
- manuscript/part4/chapter13.md（本文。src の lazy loading、skeleton、ページ内タブ、サイドバー詳細、エラー時の表示、turbo-frame refresh="morph"）
文脈確認のため: chapter11.md/chapter12.md、chapter9.md（morph）、OUTLINE.md（13.1〜13.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（コードの実動と id 一致を最優先で検証）
1. lazy loading の仕組みが公式仕様と一致するか。要検証:
   - turbo_frame_tag "id", src: path, loading: :lazy が <turbo-frame id src loading="lazy"> を生成し、frame が可視になったとき src を読み込む挙動
   - src 先レスポンスに同じ id の frame が必要（第11章の id 一致）。tasks_panel.html.erb が id="project_tasks" を満たす設計
   - frame の「最初の中身」が読み込み中プレースホルダ（skeleton）として表示され、完了後に差し替わる説明
2. ルート/コントローラ追加が正しいか。member do get :tasks_panel、tasks_panel_project_path、ProjectsController#tasks_panel と view の整合
3. タブとサイドバーの設計が破綻しないか。要検証:
   - タブ: data-turbo-frame="tab_content" で共通 content frame を差し替え、各リンク先レスポンスに id="tab_content" の frame が必要、という説明（project_path と tasks_panel が両方その id を返す必要がある点に矛盾がないか。※本文がこの前提を満たしているか確認）
   - サイドバー: 一覧リンクに data-turbo-frame="detail"、show.html.erb を turbo_frame_tag "detail" で包む。detail の中に _task（id=task_1）が入る「frame の入れ子」でインライン編集が両立する、という説明の正否
4. エラー時（404/500）の説明: エラーレスポンスにも同じ id の frame を含めないと frame が壊れる、という指摘が正確か
5. refresh="morph": turbo_frame_tag ..., refresh: :morph が <turbo-frame refresh="morph"> を生成し、frame の再読み込みを morph で行う、という記述の正否（第9章 morph・第18章との接続）
6. 本文の質（STYLEGUIDE 準拠）。第14章（失敗パターン）への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか（特に追加したルート/アクション/ビューの整合）
- Turbo Frames の最新仕様（src, loading, refresh）とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 13.4）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントや実際の挙動で確認すべき箇所は「要確認」と明示する
- 最後に、第14章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
