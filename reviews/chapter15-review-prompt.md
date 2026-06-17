# レビュー用プロンプト: 第15章 Turbo Streams の基本

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第15章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第5部 Turbo Streams の最初の章をレビューしてください。
action 名・属性・MIME type など、読者がそのまま使う要素の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。第12章で _task partial（frame id=task_1）を用意済み
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第5部の軸: 「Streams は差し替え命令の入った HTML を送る」。第14章で「複数箇所同時更新は Streams へ」と動機づけ済み

# 主なレビュー対象
- manuscript/part5/chapter15.md（本文。frame との違い、8 アクション、target/targets、turbo_stream.erb と format.turbo_stream、MIME type、refresh）
文脈確認のため: chapter14.md（frame の限界）、chapter12.md（_task）、chapter9.md（morph/page refresh）、OUTLINE.md（15.1〜15.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（公式仕様との一致を最優先）
1. Turbo Streams の仕組みが正確か。要検証:
   - <turbo-stream action target> + <template> 内に HTML を入れる構造、turbo-stream 要素は表示されず命令として処理され消える点
   - 1 レスポンスに複数 stream を入れて複数箇所を同時操作できる点（frame との違い）
2. 8 アクションが公式と一致するか。append/prepend/replace/update/remove/before/after/refresh の動作、特に replace（要素自体）と update（中身のみ）の違い、remove は template 不要、refresh は target/HTML を取らない
3. target と targets の説明。target=単一 id、targets=CSS セレクタで複数。HTML レベルの記述は正確か（※本文は targets の Rails ヘルパー（append_all 等）の名称には踏み込まず HTML レベルで説明している。これで十分か、ヘルパー名を出すべきか）
4. ビューと controller。turbo_stream.append "tasks", @task が _task partial を使う点、create.turbo_stream.erb と format.turbo_stream の対応、respond_to の書き方
5. MIME type の説明が正確か。要検証:
   - Turbo Streams の MIME は text/vnd.turbo-stream.html
   - Turbo が非 GET フォーム送信時に Accept ヘッダーへこの MIME を加えるため、respond_to が format.turbo_stream を選べる
   - だから Streams はフォーム送信（POST/PATCH/DELETE）の応答で効き、GET（一覧）には使わない、という説明の正否
6. refresh action: <turbo-stream action="refresh"> が page refresh を促し、morph 指定があれば morph で再描画、broadcast refresh（第18章）への接続
7. 本文の質（STYLEGUIDE 準拠）。第16章（CRUD の stream 化）への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか
- Turbo Streams の最新仕様（8 アクション、refresh、targets）とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 15.2）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第16章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
