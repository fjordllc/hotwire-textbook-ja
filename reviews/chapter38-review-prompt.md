# レビュー用プロンプト: 第38章 Hotwire の未来

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第38章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、本編を締める「Hotwire の未来」の章をレビューしてください。
将来予測が過度な断定になっていないか、既出の事実と整合するかを最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay
- バージョン基準: Hotwire 2026-06。確認日とバージョンを明記する方針
- 第10部の視点: 使い続けて保守できるか

# 主なレビュー対象
- manuscript/part10/chapter38.md（Turbo 8 morphing の意味／refresh broadcast／Hotwire Native の成熟／Rails 標準／SPA との境界／本書の後に学ぶこと）
文脈確認: chapter9/15/18（morph, broadcast refresh）、第9部、chapter6/37、付録A、OUTLINE.md（38.1〜38.6）

# 重点的に見てほしい観点
1. 事実と予測の区別。確実な事実（morphing は Turbo 8、Hotwire は Rails 既定、Hotwire Native は Turbo Native の後継）と、推測（今後標準化する等）が、断定と推測として書き分けられているか
2. morphing と broadcast refresh の意味づけが第9/15/18章と整合するか
3. Hotwire Native の成熟の記述が誇張でないか
4. 「Rails 標準としての Hotwire」「SPA との境界の変化」が第6/37章と整合し、偏っていないか
5. 「本書の後に学ぶこと」（公式読む=付録A、自分のアプリ、変化を追う）が実務的か
6. 本文の質（STYLEGUIDE 準拠）、本編の締めとしてふさわしいか、付録への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、最新仕様とのズレ、確認日/バージョン明記の方針との整合、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に、付録の執筆前に直すべき上位5件
```
