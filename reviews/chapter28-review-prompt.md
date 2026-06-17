# レビュー用プロンプト: 第28章 Hotwire のテスト

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第28章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、第8部 保守の最初の章（テスト戦略）をレビューしてください。
Capybara/System Test の挙動と、テスト配分の妥当性を最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。各章でミニ System Test を記述済み（8.6/12.6/16.6/20.6/23.9 など）
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap
- 第8部の軸: 「Hotwire は遅い Rails も危ない Rails も隠さない」。28章=テスト戦略、29章=観察ツール

# 主なレビュー対象
- manuscript/part8/chapter28.md（なぜ System Test か→テスト配分→Drive/Frames/Streams/Stimulus のテスト→非同期の待ち方→フレーク回避）
文脈確認: chapter8/12/16/17/20/18/23、OUTLINE.md（28.1〜28.8）

# 重点的に見てほしい観点
1. テスト配分（モデル/リクエスト/System）の切り分けが妥当か。テストピラミッドの考え方として正確か
2. Capybara の自動待機。assert_selector/assert_text/assert_no_text が条件成立まで待つ・再試行する、sleep を使わない、という記述の正否
3. 各層のテスト例の妥当性（Drive=遷移有無、Frames=within+assert_no_field、Streams=within #tasks/assert_no_text、Stimulus=fill_in→assert_selector）
4. broadcast のテスト。Action Cable が非同期でフレークしやすい、配信内容は下位テストで・結合は2セッション system test で、*_later はジョブ実行してから、という戦略の正確さ（要確認: turbo-rails/Rails の broadcast テスト手段）
5. 「更新の前に assert しない」フレーク回避が実務的か
6. 本文の質（STYLEGUIDE 準拠）、第29章への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第29章の執筆前に直すべき上位5件
```
