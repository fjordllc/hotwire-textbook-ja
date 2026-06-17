# レビュー用プロンプト: 第11章 Turbo Frames の基本

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第11章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第4部 Turbo Frames の最初の章をレビューしてください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」（第5章で Task をフラット scaffold で作成済み）
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第4部の軸: 「frame は独立した小さな visit 領域」。第3部の visit（body 差し替え）に対し、turbo-frame 単位の差し替え

# 主なレビュー対象
- manuscript/part4/chapter11.md（本文。Turbo Frames とは、turbo_frame_tag と id 一致ルール、frame 内リンク、frame 内フォーム、data-turbo-frame で別 frame を target）
文脈確認のため: chapter7.md/chapter8.md（visit と 303/422 契約）、OUTLINE.md（11.1〜11.5、第4部 intro）、STYLEGUIDE.md

# 重点的に見てほしい観点（Turbo Frames 公式仕様との一致を最優先）
1. 仕組みの説明が公式仕様と一致するか。要検証:
   - frame 内のリンク/フォームは、レスポンスから同じ id の <turbo-frame> を探して中身だけ差し替える、という id 一致ルール
   - turbo_frame_tag "task_detail" が <turbo-frame id="task_detail"> を生成する点、turbo_frame_tag dom_id(@task) が id="task_1" 相当を生成する点
   - レスポンスに一致 frame が無いときの挙動（frame が空になり Console にエラー、いわゆる "Content missing"）の説明が正確か（過度に断定していないか）
   - frame 内リンクで遷移してもブラウザの URL は変わらない、という説明（既定の挙動として正しいか。data-turbo-action="advance" の例外に触れるべきか）
   - frame 内フォームでも 303/422 契約が frame スコープで効く、成功はリダイレクト先の同 id frame、失敗は 422 で同 frame を差し替え、という説明
   - data-turbo-frame でターゲット frame を指定、_top でページ全体を visit、という説明
2. コード例が Rails 8 / Turbo で正しく動くか。turbo_frame_tag のブロック構文、link_to の data: { turbo_frame: } 表記。
3. 説明順。STYLEGUIDE の「従来（body 全体差し替え）→ なぜ過剰か → frame で一部だけ」に沿っているか。
4. 本文の質。STYLEGUIDE 準拠。第12章（インライン編集）・第13章（遅延読み込み）・第14章（失敗パターン）への接続が自然か。lazy loading（src）を本章で扱わない判断は妥当か。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか
- Turbo Frames の最新仕様とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 11.2）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第12章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
