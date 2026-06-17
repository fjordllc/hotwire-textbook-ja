# レビュー用プロンプト: 第22章 外部ライブラリと連携する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第22章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Stimulus から外部ライブラリを扱う章をレビューしてください。
ライフサイクルと Turbo cache の相互作用の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: Relay。importmap 主軸（第6章）、Stimulus は connect/disconnect が Turbo の差し替えのたびに呼ばれる（第19章）
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上

# 主なレビュー対象
- manuscript/part6/chapter22.md（connect/disconnect、動的 DOM と再接続、chart/date picker、cleanup、Turbo cache との相互作用、importmap での読み込み）
文脈確認: chapter9.md（snapshot/before-cache）、chapter6.md（importmap, CSS は別）、chapter19.md/21.md、OUTLINE.md（22.1〜22.6）

# 重点的に見てほしい観点
1. ライフサイクル。connect で初期化・disconnect で破棄という対の鉄則、connect が Turbo の差し替えのたびに呼ばれるため破棄しないと二重初期化/リークになる、という説明の正否
2. Chart.js の例（new Chart(this.element, ...) を this.chart に、disconnect で this.chart.destroy()）が妥当か。chart.js/auto の import が importmap で動くか（要確認）
3. cleanup の列挙（インスタンス destroy、clearTimeout/clearInterval、removeEventListener、要素外の DOM）が実務的か
4. Turbo cache との相互作用の説明が正確か。要検証:
   - スナップショット保存は要素が消える前（disconnect より前）に起きる、という主張
   - turbo:before-cache で teardown して、スナップショットに初期化前の DOM を残す、というパターン
   - connect で document.addEventListener("turbo:before-cache")、disconnect で removeEventListener する例の妥当性
5. importmap。bin/importmap pin chart.js、CSS は別読み込み、非 ESM は jsbundling（第6章）という整理の正否
6. 本文の質（STYLEGUIDE 準拠）。第7部への接続

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo / Stimulus バージョンで記述どおり動くか
- 最新仕様（turbo:before-cache の挙動、importmap pin）とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 重大度（Must-fix / Should-fix / Nice-to-have）でランク分け
- 各指摘に file:line（例 22.5）と具体的な修正案
- 良い点は最小限、改善点に集中
- 推測で断定せず「要確認」を明示
- 最後に第7部の執筆前に直すべき上位5件
```
