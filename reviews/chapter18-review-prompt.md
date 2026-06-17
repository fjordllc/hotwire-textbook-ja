# レビュー用プロンプト: 第18章 Action Cable でリアルタイム更新する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第18章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第5部を締める Action Cable / broadcast の章をレビューしてください。
turbo-rails の broadcast API の名称・挙動と、認可と配信範囲の切り分けを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。Task belongs_to :project。_task は turbo_frame_tag task（id=task_1）。一覧は #tasks/#task_count/#flash、一覧スコープは @tasks（第17章）。第16章で create=prepend
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸。単一チーム前提（認可は最小、詳細は第31章）
- 第5部の軸: 「Streams は差し替え命令の入った HTML を送る」。本章は経路を Action Cable に広げる

# 主なレビュー対象
- manuscript/part5/chapter18.md（本文。turbo_stream_from で購読、broadcasts_to、controller からの broadcast、配信範囲、認可の入口、実務の注意）
文脈確認のため: chapter15.md/16.md/17.md、chapter9.md（morph/refresh）、OUTLINE.md（18.1〜18.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（API 名称・挙動の正確さを最優先）
1. 購読側。要検証:
   - turbo_stream_from @project が <turbo-cable-stream-source> を描き Action Cable で購読する、という説明
   - 受け取る命令は通常の Turbo Streams と同じ HTML である点
2. broadcasts_to（model callback）。要検証:
   - broadcasts_to ->(task) { task.project } の構文と、create=append / update=replace / destroy=remove の既定動作
   - inserts_by: :prepend の指定で先頭追加になる点（オプション名が正しいか）
   - 配信される HTML がサーバー側で _task partial を描いたものである点
3. controller からの broadcast。要検証:
   - Turbo::StreamsChannel.broadcast_update_to(@project, target: "task_count", html: ...) の API 名・引数
   - broadcast_append_to / broadcast_replace_to など各 action 対応メソッドの存在
   - 「行は model callback、件数は controller broadcast」という分担の妥当性
4. 配信範囲。streamable と購読先の一致で届く範囲が決まる、広すぎる配信先の弊害（無駄通信・情報漏れ）。説明は正確か
5. 認可の入口。turbo_stream_from の購読名は署名されるが認可ではない、アクセス制御は controller/model 側、という切り分け（第15章・第31章と整合）。誤解を生まないか
6. 実務の注意。配信ごとに partial 描画 → 重い配信は *_later（非同期ジョブ）へ、N+1（第30章）、細かすぎる配信は broadcast refresh（refresh + morph）へ、seed/一括更新でも callback が走る。各記述の正確さ（特に *_later 系メソッドの存在）
7. 本文の質（STYLEGUIDE 準拠）。第6部 Stimulus への接続。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメント / GitHub の URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか（特に broadcasts_to / broadcast_*_to / *_later のメソッド名）
- Turbo / turbo-rails の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 18.2）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントやソースで確認すべき箇所は「要確認」と明示する
- 最後に、第6部の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
