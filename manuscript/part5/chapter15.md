# 第15章 Turbo Streams の基本

## この章のねらい

第14章の終わりで、Turbo Frames の限界に触れました。1 回の操作で差し替えられる frame は 1 つだけなので、「一覧の行を消し、件数を更新し、フラッシュを出す」といった<strong>複数箇所の同時更新</strong>には応えられません。

それを解決するのが Turbo Streams です。この章では、Turbo Streams の基本的な仕組み、つまり「サーバーが部分更新の命令を HTML で送る」という考え方を理解します。

> この部を貫く軸は「Streams は差し替え命令の入った HTML を送る」です。第3部の visit、第4部の frame が「1 か所をまるごと差し替える」のに対し、Turbo Streams は「どの id に、どの action を、どの HTML で」適用するかを書いた命令を送り、複数の場所を別々の action で同時に操作できます。

## 15.1 Turbo Streams とは

Turbo Frames と Turbo Streams は、名前は似ていますが、考え方が違います。

Turbo Frames は<strong>差し替え</strong>でした。`<turbo-frame>` という枠を置いておき、その枠の中身が、リンクやフォームの操作で差し替わります。きっかけは「枠の中での操作」で、対象は「その枠」です。

Turbo Streams は<strong>命令</strong>です。サーバーが「この `id` の要素に、この action を、この HTML で適用せよ」という命令を送ります。受け取ったブラウザは、その命令どおりに DOM を操作します。

命令は、見た目を持ちません。次のような HTML が送られてきます。

```html
<turbo-stream action="append" target="tasks">
  <template>
    <div id="task_1">最初のタスク</div>
  </template>
</turbo-stream>
```

これは「`id="tasks"` の要素の末尾に、この `<template>` の中身を追加せよ（append）」という命令です。`<turbo-stream>` 自体は画面に表示されず、命令として処理されると消えます。

そして、命令は<strong>1 つのレスポンスに複数入れられます</strong>。ここが frame との決定的な違いです。frame が 1 か所しか差し替えられなかったのに対し、Streams は離れた複数の場所を、それぞれ別の action で同時に操作できます。第14章で frame では応えられなかった「行を消し、件数を更新し、フラッシュを出す」が、Streams なら 3 つの命令で実現できます（第17章で実装します）。

## 15.2 8 つの action

Turbo Streams には、8 つの action があります。

| action | 何をするか |
| --- | --- |
| `append` | target の<strong>末尾</strong>に追加する |
| `prepend` | target の<strong>先頭</strong>に追加する |
| `replace` | target の要素<strong>自体</strong>を置き換える |
| `update` | target の<strong>中身</strong>だけを置き換える |
| `remove` | target を<strong>削除する</strong>（中身の HTML は不要） |
| `before` | target の<strong>直前</strong>に挿入する |
| `after` | target の<strong>直後</strong>に挿入する |
| `refresh` | ページの<strong>再描画</strong>を促す（15.6 で扱う） |

`replace` と `update` の違いに注意してください。`replace` は target の要素ごと差し替えます。`update` は target の要素は残し、その中身だけを差し替えます。タスクの行ごと入れ替えたいなら `replace`、行の中の一部分だけ変えたいなら `update`、という使い分けです。

## 15.3 target と targets

命令の宛先の指定には、2 つの形があります。

1 つは `target` です。`id` を 1 つ指定し、その 1 要素を対象にします。

```html
<turbo-stream action="replace" target="task_1"> ... </turbo-stream>
```

もう 1 つは `targets` です。CSS セレクタを指定し、<strong>当てはまるすべての要素</strong>を対象にします。

```html
<turbo-stream action="remove" targets=".done"> ... </turbo-stream>
```

これは「`.done` クラスを持つ要素を、すべて削除せよ」という命令です。1 つの命令で複数の要素をまとめて操作したいときに使います。普段は `target`（単一 id）を使い、まとめて操作したいときに `targets`（CSS セレクタ）を使う、と覚えておけば十分です。

## 15.4 `turbo_stream.erb` と `format.turbo_stream`

この命令の HTML を、Rails で手書きすることはありません。`turbo_stream` ヘルパーが組み立ててくれます。

たとえば、タスクを一覧の末尾に追加する命令は、こう書けます。

```erb
<%= turbo_stream.append "tasks", @task %>
```

`turbo_stream.append "tasks", @task` は、「`id="tasks"` の末尾に、`@task` の partial（`_task`）を append せよ」という命令の HTML を生成します。第12章で作った `_task` partial が、ここでそのまま使われます。

この命令を返すのは、`*.turbo_stream.erb` という名前のビューです。たとえば `create` アクションなら `create.turbo_stream.erb` を用意します。controller 側では、`turbo_stream` 形式に応答することを宣言します。

`app/controllers/tasks_controller.rb`（`create` の一部）

```ruby
respond_to do |format|
  if @task.save
    format.turbo_stream
    format.html { redirect_to @task }
  end
end
```

`format.turbo_stream` があると、Rails は `create.turbo_stream.erb` を探して返します。

なお、この `respond_to` は<strong>成功時だけ</strong>を抜き出した断片です。保存に失敗したときは、第8章の契約どおり 422 でフォームを返す必要があります。成功・失敗の両方を含む完全な形と、その System Test は、第16章で扱います。

## 15.5 MIME type と、なぜ POST 応答で効くか

ここで、1 つの疑問が浮かびます。なぜ Rails は、同じ `create` アクションで、あるときは通常の HTML を返し、あるときは Turbo Streams を返せるのでしょうか。

鍵は、リクエストの `Accept` ヘッダーと、Turbo Streams 専用の MIME type です。Turbo Streams の MIME type は `text/vnd.turbo-stream.html` です。

Turbo は、フォームを送信するとき（POST / PUT / PATCH / DELETE）に、`Accept` ヘッダーへ自動でこの MIME type を加えます。すると Rails の `respond_to` は、「このリクエストは Turbo Streams を受け取れる」と判断し、`format.turbo_stream` の応答を選べます。

これが、Turbo Streams が<strong>フォーム送信の応答で効く</strong>理由です。そのため Turbo Streams は、基本的に状態を変える送信（POST / PUT / PATCH / DELETE）の応答として使います。通常の GET リクエストには、この MIME type はデフォルトでは付きません。ただし、必要であれば GET でも使えます。リンクなどに `data-turbo-stream` を付けると、その GET でも Turbo Streams を受け取れるようになります（opt-in）。まずは「状態を変える送信の応答で使う」が基本だと押さえてください。

## 15.6 refresh action の使いどころ

8 つの action のうち、`refresh` だけは少し毛色が違います。target を取らず、HTML も運びません。

```html
<turbo-stream action="refresh"></turbo-stream>
```

これは「ページを再描画せよ」という命令です。受け取ると、ブラウザは第9章で見た page refresh を行います。

再描画の方法とスクロールの扱いは、refresh ストリーム自身に持たせられます。

```html
<turbo-stream action="refresh" method="morph" scroll="preserve"></turbo-stream>
```

`method="morph"` で差分適用（morph）、`scroll="preserve"` でスクロール位置の保持です。第9章で見たレイアウトの `<meta name="turbo-refresh-method">` などは、同じ設定をページ単位で与える別の経路で、両者は同じ振る舞いを指します。

`refresh` は、細かい命令を 1 つずつ組み立てる代わりに、「とにかく最新の状態に揃えてほしい」というときに向きます。とくに、複数ユーザーへ「このページを更新して」と一斉に伝えるリアルタイム更新（broadcast refresh）で効きます。これは第18章で扱います。

> 第15章では、Turbo Streams を「差し替え命令の入った HTML」として理解しました。命令は 1 つのレスポンスに複数入れられ、複数箇所を同時に操作できます。次の第16章では、Relay の作成・更新・削除を、実際に Turbo Streams で動かします。

## 参考資料

- Turbo Streams（Handbook）: <https://turbo.hotwired.dev/handbook/streams>
- Turbo Streams リファレンス: <https://turbo.hotwired.dev/reference/streams>
- Page Refreshes と morphing（Handbook）: <https://turbo.hotwired.dev/handbook/page_refreshes>
