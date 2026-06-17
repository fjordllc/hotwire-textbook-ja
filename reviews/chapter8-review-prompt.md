# レビュー用プロンプト: 第8章 リンクとフォーム送信の仕組み

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第8章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第3部の要となる章をレビューしてください。
この章は本書全体の設計の土台（フォーム契約 = 成功は redirect、失敗は 422）なので、技術的正確さを特に厳しく見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。第5章で Task をフラットな scaffold（resources :tasks）で生成済み
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第3部の軸: 「すべては visit」。第8章は「フォーム送信も visit、成功=redirect・失敗=422 render」を確立する

# 主なレビュー対象
- manuscript/part3/chapter8.md（本文。GET リンク、POST/PATCH/DELETE、成功時 redirect と 303、失敗時 422、Turbo との契約、System Test）
文脈確認のため: manuscript/part2/chapter5.md（Task の scaffold とモデル）、manuscript/part3/chapter7.md（visit）、OUTLINE.md（8.1〜8.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（フォーム契約の正確さを最優先で検証）
1. Turbo のフォーム送信仕様と一致するか。要検証:
   - Turbo が非 GET フォーム送信を横取りし、結果が redirect なら follow して visit、422 なら body を差し替える、という説明
   - 成功時に redirect を返す。Rails 8 scaffold で create は素の redirect_to、update / destroy は status: :see_other（303）である点と、その理由（PATCH/DELETE のあとリダイレクト先を GET で取得させる）
   - 失敗時に render :new, status: :unprocessable_entity（422）で返し、Turbo が 422 のボディをレンダリングして同じ画面にエラーを出す点
   - 「失敗時に 200 で返すと Turbo が再描画しない」という落とし穴の説明が正確か（過度な一般化になっていないか）
   - GET フォーム（検索）も visit になるという説明
2. コード例が Rails 8 scaffold の実際の生成物と一致するか。要検証:
   - tasks_controller の create / update / destroy の分岐とステータス
   - System Test: フラットな new_task_path を使っている点、fill_in "Title" / fill_in "Project"（project:references のラベルと入力欄が実際に "Project" でフォームに出るか）、成功文言 "Task was successfully created"、失敗時の見出し "prohibited this task from being saved" が scaffold 既定と一致するか。一致しない場合の正しい記述を指摘する
3. 説明順。STYLEGUIDE の「従来の Rails → なぜ問題 → Hotwire の解決」に沿っているか。
4. 本文の質。:unprocessable_entity と「422」の表記方針（STYLEGUIDE）に沿っているか。初級者に過不足ないか。
5. 第25章（フォーム UX）・第5部（Turbo Streams）への接続が自然か。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails バージョンで記述どおり動くか（特に scaffold の生成物とテストの整合）
- Turbo の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 8.3）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントや実際の scaffold 出力で確認すべき箇所は「要確認」と明示する
- 最後に、第9章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
