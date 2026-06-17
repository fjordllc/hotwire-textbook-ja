# 付録C Turbo Streams アクション一覧

Turbo Streams の 8 つのアクションと、対応する Rails のヘルパーをまとめます。詳細と最新仕様は、公式リファレンスで確認してください。

- Turbo Streams リファレンス: <https://turbo.hotwired.dev/reference/streams>

## 8 つのアクション

| アクション | 何をするか | ヘルパー例 |
| --- | --- | --- |
| `append` | target の末尾に追加する | `turbo_stream.append "tasks", @task` |
| `prepend` | target の先頭に追加する | `turbo_stream.prepend "tasks", @task` |
| `replace` | target の要素自体を置き換える | `turbo_stream.replace @task` |
| `update` | target の中身だけを置き換える | `turbo_stream.update "flash", partial: "layouts/flash"` |
| `remove` | target を削除する（中身の HTML は不要） | `turbo_stream.remove @task` |
| `before` | target の直前に挿入する | `turbo_stream.before "task_1", @task` |
| `after` | target の直後に挿入する | `turbo_stream.after "task_1", @task` |
| `refresh` | ページの再描画を促す | `<turbo-stream action="refresh">`（第15章） |

## target と targets

- `target` … `id` を 1 つ指定し、その 1 要素を対象にする。
- `targets` … CSS セレクタを指定し、当てはまるすべての要素を対象にする。

## 送り方の整理

| 送る経路 | 使う場面 | 登場章 |
| --- | --- | --- |
| フォーム送信の応答（`format.turbo_stream`） | 自分の操作への反映 | 第16章 |
| コントローラからの broadcast（`Turbo::StreamsChannel.broadcast_*_to`） | 他ユーザーへの配信 | 第18章 |
| モデルの callback（`broadcasts_to`） | レコードの作成・更新・削除を自動配信 | 第18章 |
| ページ内の `<turbo-stream>` 要素 | 初期表示時に命令を含める | 第15章 |

## 覚えておく要点

- `replace` は要素ごと、`update` は中身だけ（第15章）。
- 1 つのレスポンスに、複数の命令を入れられる（第16章・第17章）。
- 命令の宛先（`id`）は `dom_id` で揃えると、表示側とずれない（第17章）。
- フォーム送信の応答で効く（MIME は `text/vnd.turbo-stream.html`、第15章）。GET は既定では受け取らないが、`data-turbo-stream` で opt-in できる。

> ヘルパーの細かい引数や、ここに載せていない使い方は、公式リファレンスと turbo-rails のソースで確認してください。
