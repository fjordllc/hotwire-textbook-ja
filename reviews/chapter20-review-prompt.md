# レビュー用プロンプト: 第20章 Controller / Action / Target

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第20章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Stimulus の中心概念（controller/action/target）の章をレビューしてください。
コードがそのまま動くか、Stimulus の構文・命名規則の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。Task に title/description。_form は new/edit 共通
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第6部の軸: 「Stimulus は HTML に振る舞いを足す。状態は HTML に置く」。第19章で controller/data-controller/connect を学習済み

# 主なレビュー対象
- manuscript/part6/chapter20.md（本文。controller 作成、action、target、複数 target、命名ミス、System Test）
文脈確認のため: chapter19.md、OUTLINE.md（20.1〜20.6）、STYLEGUIDE.md

# 重点的に見てほしい観点（Stimulus 構文の正確さを最優先）
1. action。要検証:
   - data-action="input->counter#count" の書式（event->identifier#method）
   - count(event) で event.target.value.length が取れる点
   - textarea の既定イベントが input なので data-action="counter#count" と省略できる、という記述の正否（Stimulus の default event 表と一致するか）
2. target。要検証:
   - data-counter-target="input" / "output" と static targets = ["input", "output"]、this.inputTarget / this.outputTarget の対応
   - connect() で count() を呼んで初期表示する設計
   - textContent と value.length の使い方
3. 複数 target。data-bulk-target="item" 複数と static targets = ["item"]、this.itemTargets が配列、this.itemTarget(単数)との使い分け
4. 命名ミスの列挙が正確で実務的か（controller 名とファイル名、action 書式、static targets 宣言漏れ→Missing target エラー、data-<identifier>-target 属性名、単数/複数）
5. System Test。new_task_path、fill_in "Description"、assert_selector "[data-counter-target='output']", text: "5"。JS が動く driver 前提で、fill_in が input イベントを発火しカウンタが更新される、という流れが成立するか
6. 本文の質（STYLEGUIDE 準拠）。第21章（Values/Classes/Outlets）への接続

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Stimulus バージョンで記述どおり動くか（default events、static targets、this.xTarget(s)）
- Stimulus の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 20.3）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第21章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
