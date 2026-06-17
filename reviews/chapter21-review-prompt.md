# レビュー用プロンプト: 第21章 Values / Classes / Outlets

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第21章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Stimulus の Values/Classes/Outlets の章をレビューしてください。
data 属性の書式・コールバック名・API の正確さを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第6部の軸: 「状態を HTML に置く」。第19章 controller、第20章 action/target を学習済み

# 主なレビュー対象
- manuscript/part6/chapter21.md（本文。Values、CSS Classes、Outlets、状態を持つべきかの判断、HTML 側に置く利点）
文脈確認のため: chapter9.md（cache/restore）、chapter19.md/20.md、chapter27/23（toast/filter の前方参照）、OUTLINE.md（21.1〜21.5）

# 重点的に見てほしい観点（Stimulus 仕様との一致を最優先）
1. Values。要検証:
   - static values = { delay: { type: Number, default: 3000 } } の構文
   - this.delayValue で読む、data-toast-delay-value="5000" の属性書式（data-<identifier>-<name>-value）
   - 型 String/Number/Boolean/Array/Object、変更コールバック delayValueChanged() の名称
2. CSS Classes。static classes = ["hidden"]、this.hiddenClass、data-<identifier>-hidden-class="..." の書式
3. Outlets。static outlets = ["list"]、this.listOutlet、data-<identifier>-list-outlet="#selector"（CSS セレクタ）。Outlet 先 controller のメソッドを呼べる点、Stimulus のバージョン要件（要確認）
4. toast 例（connect で setTimeout→element.remove、disconnect で clearTimeout）と disclosure 例（classList.toggle(this.hiddenClass)）が動くか
5. 「状態を HTML に置く」判断と、Turbo の snapshot/restore（第9章）との接続が正確か。controller インスタンス変数の状態が差し替えで失われる、という説明の正否
6. 本文の質（STYLEGUIDE 準拠）。第22章（外部ライブラリ）への接続

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Stimulus バージョンで記述どおり動くか（Values/Classes/Outlets、特に Outlets の導入バージョン）
- Stimulus の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 21.1）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第22章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
