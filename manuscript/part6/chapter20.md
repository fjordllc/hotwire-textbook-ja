# 第20章 Controller / Action / Target

## この章のねらい

第19章では、controller を要素に結びつけ、`connect()` で振る舞いを足しました。しかし、`connect()` だけでは「結びついたとき」しか動けません。

実際の UI では、「ボタンを押したら」「入力したら」といった<strong>操作</strong>に反応し、「この要素の値を読む」「あの要素を書き換える」といった<strong>要素の出し入れ</strong>が必要です。これを担うのが action と target です。

この章では、Stimulus の 3 つの中心概念、controller・action・target を、Relay のタスク説明欄に「文字数カウンタ」を作りながら覚えます。

## 20.1 controller の作成

作るのは、入力された文字数を数えて表示するカウンタです。controller を作ります。

```bash
bin/rails generate stimulus counter
```

`app/javascript/controllers/counter_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
}
```

まだ空です。ここに、action と target を足していきます。

## 20.2 action の接続

カウンタは「入力されたとき」に動いてほしいので、入力イベントを controller のメソッドに結びつけます。これが action です。

action は、HTML 側で `data-action` 属性に書きます。書式は `イベント->controller名#メソッド名` です。

`app/views/tasks/_form.html.erb`（抜粋）

```erb
<div data-controller="counter">
  <%= form.text_area :description, data: { action: "input->counter#count" } %>
</div>
```

`input->counter#count` は、「`input` イベントが起きたら、`counter` controller の `count` メソッドを呼ぶ」という意味です。

controller 側に `count` メソッドを足します。

`app/javascript/controllers/counter_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  count(event) {
    console.log(event.target.value.length)
  }
}
```

これで、説明欄に入力するたびに、文字数が Console に出ます。`event` には、起きたイベントが渡されます。

なお、要素ごとに既定のイベントが決まっており、`textarea` の既定は `input` です。そのため、この場合は `data-action="counter#count"` とイベントを省いても同じく動きます。最初は省かずに書くと、何のイベントかが読み取りやすくなります。

## 20.3 target の参照

文字数を Console ではなく、画面に表示したいところです。表示先の要素を、controller から参照できるようにします。これが target です。

target も、HTML 側で宣言します。`data-controller名-target` 属性に、target の名前を書きます。

```erb
<div data-controller="counter">
  <%= form.text_area :description, data: { counter_target: "input", action: "input->counter#count" } %>
  <span data-counter-target="output">0</span> 文字
</div>
```

入力欄を `input`、表示先を `output` という target にしました。controller 側では、使う target の名前を `static targets` で宣言します。すると、`this.inputTarget`、`this.outputTarget` で要素を参照できます。

`app/javascript/controllers/counter_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    this.count()
  }

  count() {
    this.outputTarget.textContent = this.inputTarget.value.length
  }
}
```

`this.inputTarget` が入力欄、`this.outputTarget` が表示先です。`count` は、入力欄の文字数を表示先に書き込みます。`connect()` でも `count()` を呼んでおけば、最初の表示時にも正しい文字数が出ます（編集画面で既存の説明があるときに効きます）。

これで、入力するたびに画面の文字数が更新されます。サーバーへの問い合わせは一切ありません。

## 20.4 複数 target

target は、同じ名前を複数の要素に付けられます。その場合は、複数形の `this.名前Targets` で、配列として受け取れます。

たとえば、複数のチェックボックスをまとめて操作する controller を考えます。

```erb
<div data-controller="bulk">
  <input type="checkbox" data-action="bulk#toggleAll">すべて選択

  <input type="checkbox" data-bulk-target="item">
  <input type="checkbox" data-bulk-target="item">
  <input type="checkbox" data-bulk-target="item">
</div>
```

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  toggleAll(event) {
    this.itemTargets.forEach((item) => {
      item.checked = event.target.checked
    })
  }
}
```

`this.itemTargets` は、`data-bulk-target="item"` が付いたすべての要素の配列です。「すべて選択」を切り替えると、3 つのチェックボックスがまとめて変わります。単一なら `this.itemTarget`、複数なら `this.itemTargets`、と単数・複数で使い分けます。

## 20.5 よくある命名ミス

controller・action・target は、名前で結びつきます。だから、名前のずれが、そのままつまずきになります。代表的なものを挙げます。

- <strong>controller 名とファイル名のずれ</strong>。`data-controller="counter"` なら `counter_controller.js` です。ここがずれると、controller がまったく結びつきません。
- <strong>action の書式ミス</strong>。`イベント->controller名#メソッド名` の `->` や `#` を間違える、controller 名をタイプミスする、と動きません。
- <strong>target の宣言漏れ</strong>。`data-counter-target="output"` を付けても、controller 側の `static targets` に `"output"` を書き忘れると、`this.outputTarget` で「target が見つからない」エラーになります。
- <strong>target の属性名のずれ</strong>。target の属性は `data-controller名-target` です。`data-counter-target` を `data-target` などと書くと、結びつきません。
- <strong>単数・複数の取り違え</strong>。1 つの要素なら `this.xTarget`、複数なら `this.xTargets` です。複数あるのに単数で書くと、最初の 1 つしか取れません。

これらは、第29章のデバッグでも改めて扱います。困ったら「名前が全部そろっているか」をまず確認してください。

## 20.6 この章の System Test

文字数カウンタが動くことを、System Test で確認します。Stimulus はブラウザで動くので、JavaScript が動く System Test で確かめます。

`test/system/counter_test.rb`

```ruby
require "application_system_test_case"

class CounterTest < ApplicationSystemTestCase
  setup do
    @project = Project.create!(name: "テスト用プロジェクト")
  end

  test "説明の文字数が表示される" do
    visit new_task_path
    fill_in "Description", with: "hello"

    assert_selector "[data-counter-target='output']", text: "5"
  end
end
```

`fill_in` で説明欄に入力すると、`input` イベントが発火し、`count` が呼ばれ、`output` target に文字数が出ます。`assert_selector` で、その表示が `5` になっていることを確認します。

> 第20章では、controller・action・target で、操作に反応して要素を出し入れする振る舞いを作りました。次の第21章では、controller に設定値を渡す Values、状態を表す CSS Classes、他の controller とつなぐ Outlets を学び、「状態を HTML に置く」という第6部の軸を深めます。

## 参考資料

- Stimulus リファレンス（Actions）: <https://stimulus.hotwired.dev/reference/actions>
- Stimulus リファレンス（Targets）: <https://stimulus.hotwired.dev/reference/targets>
- Stimulus リファレンス（Controllers）: <https://stimulus.hotwired.dev/reference/controllers>
