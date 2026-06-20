# 付録E よくあるエラーと対処

Hotwire でつまずきやすいエラーと、その対処をまとめます。多くは、[第29章](../part8/chapter29.md)の観察の手順（Network → Turbo イベント → Stimulus → target → morph）で原因にたどり着けます。

## フォームを送っても何も起きない

<strong>症状</strong>: フォームを送信したのに、画面が変わらず、エラーも出ない。

<strong>原因</strong>: 失敗時に 422 ではなく 200 でフォームを返している。Turbo は、状態を変えるフォーム送信への 200 のレンダリングを行わず、送信元の URL に留まります（[第8章](../part3/chapter8.md)）。

<strong>対処</strong>: 失敗時は `render ..., status: :unprocessable_entity`（422）で返す。成功時はリダイレクト（`update` / `destroy` は `status: :see_other`）。

## frame が空になる／案内メッセージが出る（Content missing）

<strong>症状</strong>: frame の中身が消える、または「Content missing」のような案内が出て、Console に例外が出る。

<strong>原因</strong>: リンク先のレスポンスに、同じ `id` の `<turbo-frame>` がない（[第11章](../part4/chapter11.md)）。

<strong>対処</strong>: リンク元とリンク先の両方に、同じ `id` の frame があるか確認する。`dom_id` を使い、手書きの `id` がずれていないかを見る（[第17章](../part5/chapter17.md)）。

## Turbo Streams の命令が効かない

<strong>症状</strong>: stream を返しているのに、画面が更新されない。

<strong>原因</strong>: `target` が指す `id` の要素が、画面に存在しない。存在しない `id` への命令は、静かに何も起こしません（[第29章](../part8/chapter29.md)）。

<strong>対処</strong>: Network タブで stream の中身を見て、`target` の `id` が DOM にあるか、Elements タブで確認する。

## Stimulus の controller が動かない

<strong>症状</strong>: `data-controller` を付けたのに、振る舞いが動かない。

<strong>原因</strong>: controller 名とファイル名のずれ、ファイルの置き場所の誤り、target / action の名前の不一致（[第19章](../part6/chapter19.md)・[第20章](../part6/chapter20.md)）。

<strong>対処</strong>: `application.debug = true` にして、接続ログが出るか見る（[第29章](../part8/chapter29.md)）。出なければ名前と置き場所、出れば target / action の名前を疑う。

## 戻る・進むで、古い内容や壊れた表示が出る

<strong>症状</strong>: 戻る操作で、古いフラッシュや、初期化済みのウィジェットが一瞬出る。

<strong>原因</strong>: キャッシュのプレビューに、消したい要素や、JavaScript で書き換えた DOM が焼き付いている（[第9章](../part3/chapter9.md)・[第22章](../part6/chapter22.md)）。

<strong>対処</strong>: 一度きりの要素には `data-turbo-temporary` を付ける。外部ライブラリは `turbo:before-cache` で後始末する。プレビューを止めたいページは `turbo-cache-control` の `no-preview`。

## 外部ライブラリが二重に初期化される

<strong>症状</strong>: 画面を行き来すると、ライブラリが重複して動く、残骸が残る。

<strong>原因</strong>: `connect()` で初期化したものを、`disconnect()` で破棄していない（[第22章](../part6/chapter22.md)）。

<strong>対処</strong>: `disconnect()` で `destroy()` し、タイマーやリスナーも片付ける。

## リアルタイム更新が届かない

<strong>症状</strong>: 他のユーザーの操作が、自分の画面に反映されない。

<strong>原因</strong>: 購読先（`turbo_stream_from`）と配信先（`broadcasts_to` / `broadcast_*_to`）の指す相手がずれている。または、`update_all` などの一括更新で callback が走っていない（[第18章](../part5/chapter18.md)）。

<strong>対処</strong>: 購読先と配信先が同じ streamable を指しているか確認する。一括更新では broadcast が走らないことに注意する。

> 解決しないときは、最小の再現コードを作り、第29章の手順で 1 つずつ切り分けてください。
