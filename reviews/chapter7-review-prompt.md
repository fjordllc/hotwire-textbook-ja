# レビュー用プロンプト: 第7章 Turbo Drive の基本

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第7章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第3部 Turbo Drive の最初の章をレビューしてください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 目的: Hotwire を HTML over the wire という設計思想として手を動かして理解させる
- 題材: チーム向けタスク管理アプリ「Relay」（第5章で作った素の CRUD が出発点）
- バージョン基準: Hotwire は 2026-06 時点の公式ドキュメント、ハンズオンは Rails 8.0 以上、JS は importmap 主軸
- 第3部の軸: 「すべては visit である」。visit = HTML を取得し body を差し替え head をマージする

# 主なレビュー対象
- manuscript/part3/chapter7.md（本文。通常遷移との対比、visit と body 差し替え、head マージと data-turbo-track、progress bar、visit の無効化）
文脈確認のため: OUTLINE.md（7.1〜7.5、第3部 intro）、STYLEGUIDE.md、FIGURES.md（fig-7-1）

# 重点的に見てほしい観点（Turbo Drive 公式仕様との一致を最優先）
1. 仕組みの説明が公式仕様と一致するか。要検証:
   - Turbo Drive がリンククリックを横取りし、fetch で取得した HTML の body を差し替え、head をマージするという説明
   - 「visit」という語の定義と使い方（本書独自の言い換えとして妥当か、誤解を生まないか）
   - head マージの説明（読み込み済み CSS/JS は使い続ける、増えた要素は取り込む）の正確さ
   - data-turbo-track="reload": 追跡対象の新旧が変わると body 差し替えをやめて全体リロードする、という挙動
   - Rails レイアウトの既定（stylesheet_link_tag に data-turbo-track: reload、javascript_importmap_tags）の記述が実物と一致するか
   - progress bar が「既定で 500ms 遅延してから出る」という仕様の正否
   - data-turbo="false" でリンク/フォームを通常遷移に戻す、内側で data-turbo="true" に戻せる、という記述
2. 説明順。STYLEGUIDE の「従来の Rails ではどうだったか → なぜ問題か → Hotwire はどう解決するか」に沿っているか。
3. 正確さと初級者向けのバランス。restoration visit（戻る/進む）や advance/replace など、この章で触れていない概念を省いたことが妥当か、それとも一言要るか。
4. 本文の質。STYLEGUIDE 準拠（です/ます調・短文・言語ラベル・ファイル名提示）。冗長さ。
5. 第8章（フォーム送信も visit、303/422 契約）への接続が自然か。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails バージョンで記述どおり動くか
- Turbo の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 7.3）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第8章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
