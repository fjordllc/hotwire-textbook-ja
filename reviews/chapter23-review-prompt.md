# レビュー用プロンプト: 第23章 検索と絞り込み

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第23章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第7部 実務 UI パターンの最初の章（検索と絞り込み）をレビューしてください。
コードがそのまま動くか、Turbo Frames + Stimulus の組み合わせの正確さを最優先で見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: Relay。Task はフラット scaffold、status は enum、_tasks partial（root <div id="tasks">、空状態分岐）を第17章で用意
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第7部の3つの問い: サーバー状態が要るか / 更新は1か所か複数か / きっかけは誰か

# 主なレビュー対象
- manuscript/part7/chapter23.md（GET 検索→frame 化→Stimulus debounce→advance→件数の判断→a11y→テスト→アンチパターン）
文脈確認: chapter8.md（GET/visit）、chapter11.md（frame/id一致/URL不変）、chapter14.md（複数箇所はStreams）、chapter17.md（_tasks）、chapter21.md（Values）、OUTLINE.md（23.1〜23.10）

# 重点的に見てほしい観点
1. 検索の controller。where("title LIKE ?", "%#{params[:q]}%") の安全性（バインドで SQLi は防げるが LIKE のワイルドカード escape の要否に触れるべきか）、status enum での where(status: params[:status]) の妥当性
2. frame 化。form の data-turbo-frame="task_list" と turbo_frame_tag "task_list" の対応、index レスポンスに同じ frame があること、_tasks（div#tasks）を frame 内に置く構成で id 衝突がないか
3. Stimulus debounce。requestSubmit() でフォーム送信→Turbo が GET を frame に流す流れ、setTimeout/clearTimeout、Values の delay、input->search#submit（form に controller）
4. advance。turbo_frame_tag に data: { turbo_action: "advance" } を付けると frame 差し替えで URL も更新される、という記述の正否（form 側に付ける選択肢との比較）
5. 件数の判断（frame 内に入れる vs Streams）が第14章と整合するか
6. a11y。aria: { live: "polite" } の書き方、requestSubmit がフォーカスを動かさない、件数の読み上げ
7. テストの分担（System=追従、Request=絞り込み）が妥当か
8. 本文の質（STYLEGUIDE 準拠）。第24章への接続

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo / Stimulus で記述どおり動くか（form_with の GET、requestSubmit、turbo_action advance on frame）
- 最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 重大度（Must-fix / Should-fix / Nice-to-have）でランク分け、file:line と修正案
- 良い点は最小限、改善点に集中、推測は「要確認」明示
- 最後に第24章の執筆前に直すべき上位5件
```
