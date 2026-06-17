# レビュー用プロンプト: 第12章 一覧、詳細、編集フォームを Frame 化する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第12章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Turbo Frames でインライン編集を作る実装章をレビューしてください。
手順とコードがそのまま動くかを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。第5章で Task をフラット scaffold（resources :tasks）で生成。update は status: :see_other（第8章）
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第4部の軸: 「frame は独立した小さな visit 領域」。第11章で id 一致ルールを学習済み

# 主なレビュー対象
- manuscript/part4/chapter12.md（本文。一覧行を frame 化、詳細を frame 化、インライン編集、キャンセル導線、partial 設計、System Test）
文脈確認のため: chapter11.md（id 一致）、chapter8.md（303/422）、chapter5.md（scaffold）、OUTLINE.md（12.1〜12.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（コードがそのまま動くかを最優先で検証）
1. インライン編集のフローが成立するか。要検証:
   - _task を turbo_frame_tag task で囲む（dom_id(task) = "task_1"）、show が render @task で同じ frame を含む、という設計で「編集→保存→表示に戻る」が回るか
   - 編集リンク（frame task_1 内）→ edit.html.erb の frame task_1（_form を内包）が抽出されて差し替わる流れ
   - 保存成功時: update の redirect（see_other）先（show）から frame task_1 を抽出して表示に戻る、という説明が正しいか
   - 保存失敗時: 422 で edit を再描画し frame task_1 にエラー付きフォームが入る、という説明が正しいか
   - キャンセル（task_path への link、frame 内）で表示の _task に戻る流れ
   - 上記が「id を全側で task_1 に揃える」前提で破綻しないか（show.html.erb が frame を含むこと、index の render @tasks が _task を繰り返すこと）
2. コードの正確さ。turbo_frame_tag task の dom_id 省略記法、_task/_form/edit/show の各ファイルの内容が Rails 8 scaffold を改変したものとして自然か。update アクションは scaffold のままで動くという記述の正否。
3. System Test。within "##{dom_id(task)}" の使い方、ボタン名 "編集"/"Update Task"、tasks_path（フラット）が実際に動くか。fill_in "Title" のラベル。
4. partial 設計の主張（_task を表示の単一の源にする）が妥当で、初級者に伝わるか。
5. 説明順・本文の質（STYLEGUIDE 準拠）。第13章（lazy loading）への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか（特に scaffold 改変後の整合とテスト）
- Turbo Frames の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 12.3）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントや実際の scaffold 出力で確認すべき箇所は「要確認」と明示する
- 最後に、第13章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
