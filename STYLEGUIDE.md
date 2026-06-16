# 執筆スタイル・用語統一方針

全章でこのルールに従います。表記の揺れは読者の負担になるため、ここを唯一の基準とします。

## 1. バージョン前提

- 本文は **2026年6月時点の Hotwire 公式ドキュメント**を基準に書きます。
- Turbo / Stimulus / Hotwire Native のバージョン差に触れるときは、必ず確認日と対象バージョンを明記します。
- ハンズオン（サンプルアプリ Relay）は **Rails 8.0 以上**を前提にします。これは独立した 2 つの理由によります。(1) Rails 8 標準の認証ジェネレータ（`bin/rails generate authentication`）を使うため。(2) JavaScript 構成を importmap 既定に揃えるため。両者は別々の決定であり、互いに依存しません。
- 概念説明そのものは Rails 7.2 以降にも当てはまりますが、コード手順は Rails 8.0 以上で動作確認します。特定の Rails バージョンに依存する記述は、確認日とバージョンを本文中に明記します。

## 2. 文体

- です/ます調。1 文を短く。1 段落 1 トピック。
- Rails 学習済みの初級者を想定し、Rails の基礎説明は必要最小限にします。
- 初出の用語は補足します。
- 「なぜ」を必ず添えます。機能の列挙で終わらせません。
- 各概念は **「従来の Rails ではどう書いていたか → なぜ問題か → Hotwire はどう解決するか」** の順で説明します。

## 3. 用語の統一表記

| 採用する表記 | 使わない／揺らさない |
| --- | --- |
| Hotwire | hotwire、HOTWIRE |
| HTML over the wire | HTML-over-the-wire、HTML Over The Wire |
| Turbo Drive | Drive 単体表記は避ける |
| Turbo Frames | Turbo Frame、Frames（見出しでは避ける） |
| Turbo Streams | Turbo Stream、Streams（見出しでは避ける） |
| Stimulus | stimulus、StimulusJS |
| コントローラ | controller、コントローラー |
| アクション | action |
| ターゲット | target |
| 値（Values） | Value、バリュー |
| クラス（CSS Classes） | CSS class helper などに揺らさない |
| Outlets | アウトレット（必要時のみ併記） |
| Hotwire Native | Turbo Native（歴史的説明以外では避ける） |
| Path Configuration | パス設定（必要時のみ併記） |
| Bridge Components | ブリッジコンポーネント（必要時のみ併記） |

## 4. コード例のルール

- 言語ラベルを必ず付けます（```erb / ```ruby / ```js / ```ts / ```html / ```bash / ```swift / ```kotlin）。
- ファイル名が重要なときはコードブロック直前に `app/views/tasks/index.html.erb` のように示します。
- Rails のコード例は、View・Controller・Model・Routes の関係が追えるようにします。
- ハンズオンでは「変更前 → 変更後 → 動作確認」の順に示します。
- 長いコードを一度に出しすぎず、読者が入力・確認できる単位に分けます。
- バリデーション失敗時の HTTP ステータスは、本文では「422」と表記し、コードでは `status: :unprocessable_entity` を使います（Rails の標準シンボルに合わせるため）。

## 5. 参考資料セクション

- 各章末に必ず `## 参考資料` を置きます。
- URL を必ず明記します。
- 一次情報（公式 docs / GitHub / リリースノート / 37signals・Hotwire 関係者の発信）を優先し、第三者ブログは補助に留めます。
- 掲載前に URL の実在を確認します。

## 6. Markdown / mdBook の注意

- 日本語文中で強調を使うとき、前後の日本語と `**...**` を密着させないようにします。
- 文中に自然に埋め込む強調は、必要に応じて `<strong>...</strong>` を使います。
- 修正後は `mdbook build` を実行し、生成 HTML に意図しない `**` が残っていないか確認します。

```bash
rg -n "\*\*" book -g '*.html' -g '!searchindex.js'
```

## 7. 確認済みの基準 URL

- Hotwire: <https://hotwired.dev/>
- Turbo: <https://turbo.hotwired.dev/>
- Stimulus: <https://stimulus.hotwired.dev/>
- Hotwire Native: <https://native.hotwired.dev/>
- Rails Guides: <https://guides.rubyonrails.org/>
