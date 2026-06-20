# 付録G 完成版サンプルアプリのコード解説

本書を通して育てた Relay の全体像を、ファイルの役割と、対応する章で振り返ります。各部分が「どの章で、なぜそう作ったか」を、まとめて見渡せます。

## モデル

| ファイル | 役割 | 章 |
| --- | --- | --- |
| `app/models/user.rb` | ログインユーザー。担当タスク・コメントを持つ | [第5章](../part2/chapter5.md) |
| `app/models/project.rb` | タスクをまとめる単位 | [第5章](../part2/chapter5.md) |
| `app/models/task.rb` | 中心リソース。`status` enum、`broadcasts_to` | [第5章](../part2/chapter5.md)・[第18章](../part5/chapter18.md) |
| `app/models/comment.rb` / `tag.rb` / `tagging.rb` | コメント・タグ（中間モデル含む） | [第5章](../part2/chapter5.md) |

`Task#status` の enum（`todo` / `in_progress` / `done`）は、検索・絞り込み・バリデーション・表示の軸になりました（[第4章](../part2/chapter4.md)）。

## コントローラ

`app/controllers/tasks_controller.rb` が中心です。

- `index` … 検索・絞り込み（`sanitize_sql_like`）、ページネーション、一覧スコープ `@tasks`（[第23章](../part7/chapter23.md)・[第24章](../part7/chapter24.md)・[第17章](../part5/chapter17.md)）。
- `create` / `update` / `destroy` … 成功は redirect / Turbo Streams、失敗は 422（[第8章](../part3/chapter8.md)・[第16章](../part5/chapter16.md)）。`format.turbo_stream` と `format.html` の両方を持つ。

認可は controller で行います（[第31章](../part8/chapter31.md)）。Relay は単一チーム前提なので最小限です。

## ビューと partial

| ファイル | 役割 | 章 |
| --- | --- | --- |
| `app/views/tasks/_task.html.erb` | タスク 1 件の表示（`turbo_frame_tag`） | [第12章](../part4/chapter12.md) |
| `app/views/tasks/_tasks.html.erb` | 一覧領域（空状態の分岐込み） | [第17章](../part5/chapter17.md) |
| `app/views/tasks/_form.html.erb` | フォーム（a11y 属性） | [第25章](../part7/chapter25.md) |
| `app/views/tasks/*.turbo_stream.erb` | create / destroy などの stream 命令 | [第16章](../part5/chapter16.md) |
| `app/views/layouts/_flash.html.erb` | フラッシュ（`#flash` / `aria-live`） | [第27章](../part7/chapter27.md) |

partial を一覧と stream で共通化したのが、設計の要でした（[第12章](../part4/chapter12.md)・[第17章](../part5/chapter17.md)）。

## Stimulus controller

| ファイル | 役割 | 章 |
| --- | --- | --- |
| `autofocus_controller.js` | 要素にフォーカス（エラーサマリにも再利用） | [第19章](../part6/chapter19.md)・[第25章](../part7/chapter25.md) |
| `counter_controller.js` | 文字数カウンタ | [第20章](../part6/chapter20.md) |
| `toast_controller.js` | トーストの自動消滅・閉じる（Values の delay） | [第21章](../part6/chapter21.md)・[第27章](../part7/chapter27.md) |
| `search_controller.js` | 入力の debounce 送信 | [第23章](../part7/chapter23.md) |
| `infinite_scroll_controller.js` | IntersectionObserver で自動読み込み | [第24章](../part7/chapter24.md) |
| `dropdown_controller.js` / `modal_controller.js` | ドロップダウン・モーダル | [第26章](../part7/chapter26.md) |
| `chart_controller.js` など | 外部ライブラリ連携 | [第22章](../part6/chapter22.md) |

どれも `connect` / `disconnect` を対にし、状態は HTML 側に置きました（[第6部](../part6/index.md)）。

## リアルタイム

- `turbo_stream_from`（購読、ログイン時のみ）と `broadcasts_to` / `broadcast_*_to`（配信）でリアルタイム更新（[第18章](../part5/chapter18.md)・[第27章](../part7/chapter27.md)）。
- 配信範囲と認可に注意（[第31章](../part8/chapter31.md)）。

## 読み進め方

このアプリは、第2部で素の CRUD を作り、第3部以降で 1 つずつ Hotwire 化したものです。各ファイルを見るときは、対応する章に戻ると、「なぜそう書いたか」がたどれます。最初の素の状態から、段階を追って育てたことが、コード全体に表れています。

完成版の Relay のコード一式は、次のリポジトリで公開しています。

- <https://github.com/fjordllc/Relay>

手元のコードと突き合わせながら読むと、各章の差分が追いやすくなります。
