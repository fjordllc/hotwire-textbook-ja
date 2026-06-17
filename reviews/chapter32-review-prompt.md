# レビュー用プロンプト: 第32章 Hotwire Native の考え方

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第32章を書き起こした時点のものです。

```text
あなたは Rails / Hotwire / モバイル（iOS Swift・Android Kotlin）に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、第9部 Hotwire Native の最初の章をレビューしてください。
Hotwire Native（2026 時点）の事実関係の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay（Web で作り込み済み）。第5章でログイン、第7部で UI 品質
- バージョン基準: Hotwire 2026-06。実機ビルド手順は付録H（本編は考え方中心）
- 第9部の軸: 「同じ Relay をネイティブの殻で包む」Web-first

# 主なレビュー対象
- manuscript/part9/chapter32.md（Hotwire Native とは／WebView と native shell／すべてをネイティブ化しない判断／Web 側に求められる設計／iOS・Android の違い）
文脈確認: chapter14（URL と画面状態）、chapter5/第7部、OUTLINE.md（32.1〜32.5、第9部 intro）

# 重点的に見てほしい観点（Hotwire Native の事実確認を最優先）
1. Hotwire Native の位置づけ（Turbo Native の後継、iOS/Android 統一ブランド）が正確か。WebView + native shell の構成説明
2. Web-first の利点（Web 更新がアプリに反映、ストア再申請不要で画面更新できる範囲）の記述が誇張でないか（ネイティブシェル自体の更新はストア経由、という限界に触れるべきか）
3. すべてをネイティブ化しない判断（カメラ/決済/通知などはネイティブ、多くは Web）の妥当性
4. Web 側要件（レスポンシブ、素直なナビゲーション/URL対応、認証はWebViewがWebセッションを共有）の正確さ。セッション/cookie 共有の説明は要確認
5. iOS=Swift / Android=Kotlin、共通概念（Path Configuration / Bridge Components）の前振りが正確か
6. 本文の質（STYLEGUIDE 準拠）、第33章への接続、付録H への送り

# 常設チェック（REVIEW_NOTES.md）
- URL 実在（native.hotwired.dev）、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第33章の執筆前に直すべき上位5件
```
