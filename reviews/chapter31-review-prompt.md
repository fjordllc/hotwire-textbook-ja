# レビュー用プロンプト: 第31章 認証、認可、セキュリティ

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第31章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、第8部を締めるセキュリティ章をレビューしてください。
署名と認可の切り分け、CSRF、broadcast 配信範囲の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。単一チーム前提（認可は最小）。第18章 broadcast、第27章 turbo_stream_from current_user、第17章 dom_id
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap

# 主なレビュー対象
- manuscript/part8/chapter31.md（controller 認可を省略しない→Frame/Stream でも権限→broadcast 配信範囲→署名付き stream 名≠認可→CSRF→ユーザーごとの DOM id→第18章との責務分担）
文脈確認: chapter18/27/17/15、OUTLINE.md（31.1〜31.7）

# 重点的に見てほしい観点
1. 「frame/stream を返すアクションも独立リクエストで、同じ認可が要る」という主張の正確さ
2. broadcast 配信範囲＝認可、広すぎる配信先の弊害、配信内容に秘密を含めない、が正確か
3. 署名付き stream 名（turbo_stream_from）は改ざん防止であって認可ではない、アクセス制御は controller/model 側、という切り分け（第18章と整合）
4. CSRF。要検証: form_with は CSRF トークンを埋め込む、Turbo はフォーム送信時にトークンを含めて送る、自前 fetch では csrf-token メタからトークンを付ける必要、という記述の正否
5. dom_id は推測可能なので認可を曖昧さに頼らない、ユーザーごとは署名付き stream 名で分ける、が妥当か
6. 第18章（仕組み）と第31章（責任）の責務分担が明快か。単一チーム前提での最小実装とマルチテナントへの一般化が適切か
7. 本文の質（STYLEGUIDE 準拠）、第9部への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第9部の執筆前に直すべき上位5件
```
