# レビュー用プロンプト: 第19章 Stimulus の基本

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第19章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第6部 Stimulus の最初の章をレビューしてください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」。importmap + stimulus-rails、controllers は eagerLoadControllersFrom で自動登録（第6章）
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第6部の軸: 「Stimulus は HTML に振る舞いを足す。状態は HTML に置く」。第3〜5部はサーバー主体の更新

# 主なレビュー対象
- manuscript/part6/chapter19.md（本文。Stimulus の思想、controller、data-controller、Rails での配置、Turbo との関係）
文脈確認のため: chapter6.md（stimulus-rails / 自動登録）、chapter7.md/9.md（visit / cache）、OUTLINE.md（19.1〜19.5、第6部 intro）、STYLEGUIDE.md

# 重点的に見てほしい観点（Stimulus 公式仕様との一致を最優先）
1. 思想の説明が正確か。DOMContentLoaded が初回しか発火せず Turbo 遷移後に動かない、という問題提起の正否
2. controller の書き方。import { Controller } from "@hotwired/stimulus"、export default class extends Controller、connect()、this.element の説明が正確か。bin/rails generate stimulus autofocus が雛形を作る点
3. data-controller の対応規則。autofocus_controller.js → data-controller="autofocus"、複数は空白区切り、サブディレクトリは -- 区切り（users--list）、_controller.js を除いた部分が identifier、という規則が正確か
4. 配置と自動登録。app/javascript/controllers、eagerLoadControllersFrom で手動登録不要（第6章と整合）
5. Turbo との関係。connect()/disconnect() が初回だけでなく Turbo の差し替え（visit / frame / streams）のたびに呼ばれる、という説明の正否。これが Stimulus を使う理由だという位置づけ
6. autofocus の例（connect で this.element.focus()、form.text_field の data: { controller: "autofocus" }）が動くか、初級者向けの最初の例として妥当か
7. 本文の質（STYLEGUIDE 準拠、従来→問題→Hotwire の解決順）。第20章（controller/action/target）への接続

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Stimulus バージョンで記述どおり動くか
- Stimulus の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 19.4）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第20章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
