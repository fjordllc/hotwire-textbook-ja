# レビュー用プロンプト: 第9章 キャッシュ、プレビュー、リロード、morphing

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第9章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼技術書のテクニカルレビュアーです。
制作中の日本語技術書「Hotwire 教科書（FBC Press）」の、第3部の後半（キャッシュと Turbo 8 morphing）をレビューしてください。
読者がそのまま写す属性・meta タグが多い章なので、表記の正確さを特に厳しく見てください。

# 本書の前提
- 読者: Rails の基礎を学習済みの初級エンジニア
- 題材: チーム向けタスク管理アプリ「Relay」
- バージョン基準: Hotwire は 2026-06、Rails 8.0 以上、importmap 主軸
- 第3部の軸: 「すべては visit」。第7章で application visit / restoration visit を区別済み

# 主なレビュー対象
- manuscript/part3/chapter9.md（本文。前半=snapshot cache / preview / data-turbo-cache / data-turbo-track / Stimulus との関係、後半=page refresh と morph / turbo-refresh-method / turbo-refresh-scroll / data-turbo-permanent / turbo-stream action="refresh"）
文脈確認のため: manuscript/part3/chapter7.md（visit, data-turbo-track）、OUTLINE.md（9.1〜9.10）、STYLEGUIDE.md

# 重点的に見てほしい観点（公式仕様・属性表記との一致を最優先）
1. キャッシュ/プレビューの説明が正確か。要検証:
   - snapshot cache が「離れる直前にスナップショットを保存し、restoration visit で即時表示」する説明
   - preview: キャッシュ済み URL への visit でキャッシュ版を即時表示し、裏で最新を取得して差し替える挙動、`<html data-turbo-preview>` 属性
   - data-turbo-cache="false" は「要素をスナップショットから除外する」、ページ全体の無効化は `<meta name="turbo-cache-control" content="no-cache">` という使い分けが正しいか
   - turbo:before-cache と Stimulus の disconnect/connect の関係
2. morphing の表記が公式どおり正確か（読者がそのまま写す）。要検証:
   - `<meta name="turbo-refresh-method" content="morph">`（content は morph / replace、既定 replace）
   - `<meta name="turbo-refresh-scroll" content="preserve">`（content は preserve / reset、既定 reset）
   - `data-turbo-permanent` は id で識別され保持・morph 対象外という説明
   - `<turbo-stream action="refresh" method="morph" scroll="preserve">` の属性
   - page refresh が「同一 URL への visit」を指すという説明、broadcast refresh（第18章）への接続
3. 用語と接続。restoration visit（第7章）との接続、第18章・第22章への送りが自然か。morph の内部（idiomorph）に触れない判断は妥当か。
4. 本文の質。STYLEGUIDE 準拠（です/ます調・コードの言語ラベル）。初級者に過不足ないか、前後半の切り替えが明確か。

# 常設チェック（REVIEW_NOTES.md より）
- 公式ドキュメントの URL が実在するか
- 対象 Rails / Turbo バージョンで記述どおり動くか
- Turbo の最新仕様（特に Turbo 8 の page refresh / morphing）とずれていないか
- 各記述に「なぜそうするのか」があるか

# 出力形式
- 指摘は重大度（Must-fix / Should-fix / Nice-to-have）でランク分けする
- 各指摘に file:line（またはセクション番号 例 9.7）と具体的な修正案を付ける
- 良い点の列挙は最小限にし、改善点に集中する
- 推測で断定せず、公式ドキュメントで確認すべき箇所は「要確認」と明示する
- 最後に、第10章の執筆に進む前に直すべき上位5件を優先順位付きでまとめる
```
