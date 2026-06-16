# レビュー用プロンプト: 第6章 Hotwire の標準構成を確認する

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第6章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、Hotwire の標準構成を解説する章をレビューしてください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 目的: Hotwire を HTML over the wire という設計思想として手を動かして理解させる
- 題材: チーム向けタスク管理アプリ「Relay」
- バージョン基準: Hotwire は 2026-06 時点の公式ドキュメント、ハンズオンは Rails 8.0 以上、JS は importmap 主軸
- この章の位置づけ: 第2部の最終章。Hotwire 関連ファイルと読み込み経路の把握、importmap 採用の理由と限界

# 主なレビュー対象
- manuscript/part2/chapter6.md（本文。turbo-rails / stimulus-rails / importmap / jsbundling / 外部ライブラリ / 開発時のログと DevTools）
文脈確認のため: manuscript/part2/chapter5.md、OUTLINE.md（6.1〜6.7）、STYLEGUIDE.md

# 重点的に見てほしい観点（Rails 8 + importmap の実挙動との一致を最優先）
1. ファイル内容とパスが Rails 8（importmap + turbo-rails + stimulus-rails）の既定と一致するか。要検証:
   - app/javascript/application.js の `import "@hotwired/turbo-rails"` / `import "controllers"`
   - app/javascript/controllers/application.js（Application.start / application.debug / window.Stimulus / export）
   - app/javascript/controllers/index.js（`eagerLoadControllersFrom("controllers", application)` と stimulus-loading の import）
   - config/importmap.rb の既定 pin（application / @hotwired/turbo-rails to: turbo.min.js / @hotwired/stimulus / @hotwired/stimulus-loading / pin_all_from app/javascript/controllers under: controllers）
   - `bin/importmap json` と `bin/importmap pin <name>` の用法
2. turbo-rails / stimulus-rails の役割説明が正確か（ブラウザ側ライブラリ＋サーバ側ヘルパー、コントローラ自動登録）。
3. importmap と jsbundling の使い分けの記述が妥当か。importmap が CSS を扱わない・非 ESM ライブラリで難しい場合がある、という限界の説明が正確か。
4. 開発時の観察ポイントが正しいか。要検証:
   - サーバログの `Processing as TURBO_STREAM`
   - Turbo Streams レスポンスの MIME `text/vnd.turbo-stream.html`
   - `application.debug = true` で Stimulus の接続状況が出る、という記述
5. 本文の質。STYLEGUIDE 準拠（です/ます調・言語ラベル・ファイル名提示）。初級者にとって過不足ない情報量か。第3部への接続が自然か。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails バージョンで記述どおり動くか
- Turbo / Stimulus の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 6.2）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第3部の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
