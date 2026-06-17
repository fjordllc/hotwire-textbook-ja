# ハンズオン（第5部）: 画面遷移なしで追加・更新・削除する

Turbo Streams で、Relay の作成・更新・削除を画面遷移なしに反映し、最後はリアルタイム更新まで広げます。

## この部の到達状態

- タスクの作成・更新・削除が prepend / replace / remove で反映される
- 1 レスポンスで、行・件数・flash・空状態を同時に更新できる
- コメントの追加・削除が部分更新で動く
- Action Cable で、同じタスクを見ている全員にライブで反映される

## 作る・変える

1. `format.turbo_stream` で create / update / destroy を stream 化する
2. 複数 stream を 1 レスポンスに束ね、件数・空状態・flash を同時に更新する
3. `broadcasts_to` / `turbo_stream_from` で broadcast を足す

## 完成条件

- 2 つの画面を開き、片方の操作がもう片方に反映される
- 最後の 1 件を消すと空状態が表示される
- これらを System Test で確認できる

## Relay の現在地

<strong>部分更新・複数同時更新・リアルタイム更新が揃った状態。</strong> 次の第6部で、サーバー不要の振る舞いを Stimulus で足します。
