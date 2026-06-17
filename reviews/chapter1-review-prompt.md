# レビュー用プロンプト: 第1章 Hotwire とは何か

```text
あなたは Rails と Hotwire に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、本書冒頭の章をレビューしてください。
初学者の最初の一歩として、正確さと分かりやすさのバランスを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay（後の部で育てる）
- バージョン基準: Hotwire 2026-06、Rails 8.0+

# 主なレビュー対象
- manuscript/part1/chapter1.md（Hotwire の全体像／Turbo・Stimulus・Native の役割／JSON+SPA との違い／Rails 標準である意味／Relay の見取り図）
文脈確認: OUTLINE.md（1.1〜1.5）、chapter6（Rails 既定）、第10部（SPA 比較）

# 観点
1. 「HTML OVER THE WIRE」の説明、Turbo（Drive/Frames/Streams）/Stimulus/Native の役割分担が正確か
2. SPA との違いの説明が公平か（この段階で深入りしすぎず第10部へ送れているか）
3. Rails 標準である意味の記述が正確か
4. 設計思想として捉える、というトーンが本書の主旨と一貫するか
5. 本文の質（STYLEGUIDE 準拠）、第2章への接続

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 上位5件
```
