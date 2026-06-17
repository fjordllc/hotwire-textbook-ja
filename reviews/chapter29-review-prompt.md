# レビュー用プロンプト: 第29章 デバッグとイベント観察

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第29章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、デバッグと観察の章をレビューしてください。
DevTools/イベント/属性の事実関係の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap
- 第8部の軸: Hotwire は遅い/危ない Rails を隠さない。29章=観察ツール（a11y の方針は第7部、ここは原因切り分け）

# 主なレビュー対象
- manuscript/part8/chapter29.md（Network→Turbo イベント→Stimulus 接続→Frame/Stream target→morph→focus/aria 切り分け→よくあるエラー）
文脈確認: chapter6/10/11/15/17/9、OUTLINE.md（29.1〜29.7）、付録E

# 重点的に見てほしい観点
1. Network の観察点（メソッド、Accept: text/vnd.turbo-stream.html、303/422、turbo-stream/frame の中身）が正確か
2. Turbo イベントのログ（turbo:visit/submit-start/submit-end/before-render/render/frame-load）の名称が正しいか。turbo:frame-load は実在するか（要確認）
3. Stimulus 接続確認（application.debug = true でログ、window.Stimulus、data-controller とファイル名のずれ）が正確か
4. target 不一致の発見（frame の id 不一致→案内メッセージ＋例外、stream の target 不在→静かに無反応）が正確か
5. morph の観察（turbo:before-morph-element で対象要素、data-turbo-permanent との関係）が正確か
6. focus/aria 切り分け（document.activeElement、アクセシビリティツリー）が妥当で、a11y 方針（第7部）と役割が重複していないか
7. よくあるエラーの対応づけが妥当か。付録E への送りが自然か
8. 本文の質（STYLEGUIDE 準拠）、第30章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第30章の執筆前に直すべき上位5件
```
