# 第26章 モーダル、タブ、ドロップダウン

## この章のねらい

モーダル、タブ、ドロップダウン。どれも見慣れた UI ですが、Hotwire では「何で作るか」が一つに決まりません。サーバーの内容が要るかどうかで、実装が分かれるからです。

この章では、その仕分けを学びます。サーバーの内容が要らないものは Stimulus だけで、サーバーから内容を取るものは Turbo Frames や Turbo Streams で作ります。

## 26.1 完成イメージ

- ドロップダウン … ボタンを押すとメニューが開く。中身は最初からある
- タブ … 切り替えで表示が変わる。中身が最初からある「静的タブ」と、開いたときにサーバーから取る「遅延タブ」がある
- モーダル … 「新規作成」を押すと、サーバーからフォームを取って重ねて表示する

## 26.2 この章の選択

判断の軸は「サーバーの状態（内容）が要るか」です。

- ドロップダウンや静的タブは、中身が最初からページにあります。開閉や切り替えはサーバー往復が要りません。だから Stimulus だけで作ります。
- 遅延タブやモーダルは、中身をサーバーから取ります。だから Turbo Frames や Turbo Streams を使います。

同じ「重ねて表示する」見た目でも、中身がどこから来るかで道具が変わります。

## 26.3 ドロップダウンを Stimulus だけで作る

ドロップダウンは、サーバーと関係ありません。Stimulus だけで作ります。

`app/javascript/controllers/dropdown_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const willOpen = this.menuTarget.hidden
    this.menuTarget.hidden = !willOpen
    this.buttonTarget.setAttribute("aria-expanded", String(willOpen))
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.hidden = true
      this.buttonTarget.setAttribute("aria-expanded", "false")
    }
  }
}
```

```erb
<div data-controller="dropdown" data-action="click@window->dropdown#close">
  <button data-dropdown-target="button" data-action="dropdown#toggle"
          aria-haspopup="true" aria-expanded="false">メニュー</button>
  <ul data-dropdown-target="menu" hidden>
    <li>...</li>
  </ul>
</div>
```

`toggle` でメニューの表示を切り替え、あわせて開閉状態を `aria-expanded` に反映します。`click@window->dropdown#close` で、外側をクリックしたときに閉じます（`@window` は window で起きたイベントを拾う書き方です）。サーバーへの問い合わせは一切ありません。

## 26.4 静的タブを Stimulus だけで作る

中身が最初からページにあるタブも、Stimulus だけで作れます。選ばれたタブのパネルを表示し、ほかを隠すだけです。

このとき、アクセシビリティのために、タブには適切な役割（role）を付けます。`tablist`・`tab`・`tabpanel` です。これは 26.8 でまとめて扱います。中身がすでにあるので、切り替えはサーバーと無関係で、Stimulus が表示を出し入れします。

## 26.5 遅延タブを Turbo Frames で読み込む

タブの中身が重い、あるいは最初は要らない場合は、開いたときにサーバーから取ります。これは第13章で見た遅延読み込みです。

タブのリンクで、共通の content frame を差し替えます。

```erb
<nav role="tablist">
  <%= link_to "概要", overview_project_path(@project), role: "tab", data: { turbo_frame: "tab_content" } %>
  <%= link_to "タスク", tasklist_project_path(@project), role: "tab", data: { turbo_frame: "tab_content" } %>
</nav>

<%= turbo_frame_tag "tab_content" do %>
  <p>タブを選んでください。</p>
<% end %>
```

各タブの行き先が `id="tab_content"` の frame を返します（第13章）。中身をサーバーから取るので、Stimulus 単独ではなく Turbo Frames です。

## 26.6 モーダルを Turbo Frames と `<dialog>` で作る

モーダルは、サーバーからフォームを取って重ねます。Turbo Frames で内容を取り、`<dialog>` 要素で重ねて表示します。

まず、レイアウトに空のモーダル用 frame を置きます。

```erb
<%= turbo_frame_tag "modal" %>
```

「新規作成」リンクで、この frame を差し替えます。

```erb
<%= link_to "新規作成", new_task_path, data: { turbo_frame: "modal" } %>
```

`new.html.erb` は、`id="modal"` の frame の中に `<dialog>` を置き、Stimulus で開きます。

`app/views/tasks/new.html.erb`

```erb
<%= turbo_frame_tag "modal" do %>
  <dialog data-controller="modal" data-action="close->modal#cleanup">
    <%= render "form", task: @task %>
  </dialog>
<% end %>
```

`app/javascript/controllers/modal_controller.js`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.showModal()
  }

  cleanup() {
    this.element.remove()
  }
}
```

`connect()` で `showModal()` を呼ぶと、`<dialog>` がモーダルとして開きます。「新規作成」を押すと、`new_task_path` の内容が `modal` frame に入り、`connect()` が走ってモーダルが開きます。`data-action="close->modal#cleanup"` は、`Esc` などで `<dialog>` が閉じたとき（`close` イベント）に `cleanup` を呼び、閉じたダイアログ要素を DOM から取り除きます。残骸を残さないための後始末です。

## 26.7 成功時に Streams でモーダルを空にする

モーダルの中のフォームを送信して成功したら、モーダルを閉じ、一覧を更新します。これは複数箇所の更新なので、Turbo Streams です（第16章）。

`app/views/tasks/create.turbo_stream.erb`（成功時）

```erb
<%= turbo_stream.prepend "tasks", @task %>
<%= turbo_stream.update "modal" %>
<%= turbo_stream.update "flash", partial: "layouts/flash" %>
```

`turbo_stream.update "modal"`（中身なし）で、モーダル frame を空にします。中の `<dialog>` ごと消えるので、モーダルが閉じます。同時に、一覧の先頭へタスクを追加し、フラッシュを出します。失敗時は、第25章のとおり 422 でフォームを差し替え、モーダルは開いたままにします。

## 26.8 a11y

モーダルとタブは、アクセシビリティの作り込みが要ります。

- <strong>モーダル</strong>。`<dialog>` を `showModal()` で開くと、フォーカスがダイアログ内に閉じ込められ（focus trap）、`Esc` で閉じられ、開閉に伴うフォーカスの移動も、ブラウザがかなり面倒を見てくれます。これが、`<div>` で自作せず `<dialog>` を使う理由です。自作すると、focus trap も Esc も自分で実装することになり、抜けが出ます。
- <strong>タブ</strong>。`role="tablist"`・`role="tab"`・`role="tabpanel"` を付け、選択中のタブを `aria-selected="true"` にします。矢印キーでの移動なども、タブの標準的な振る舞いです。
- <strong>ドロップダウン</strong>。開閉ボタンに `aria-expanded` を付け、`Esc` で閉じ、キーボードで項目をたどれるようにします。

## 26.9 URL: モーダルをディープリンクにするか

モーダルには、URL の設計判断があります。`/tasks/new` を開いた状態を URL に残す（ディープリンク）か、残さないかです。

残さない場合は、26.6 のように frame の差し替えだけで開きます（URL は変わりません）。手軽ですが、モーダルを開いた URL を共有・リロードで再現できません。残したい場合は、第14章の `data-turbo-action="advance"` を使い、モーダルを開く遷移を URL に積みます。

多くのモーダル（作成・編集など）は、ディープリンクが不要です。まずは URL を変えない素朴な形から始め、共有が必要になったら advance を検討します。

## 26.10 テスト

モーダルは、System Test で次を確かめます。

- 「新規作成」で開く
- `Esc` で閉じる
- 送信に成功すると、モーダルが閉じ、一覧にタスクが追加される

ドロップダウンやタブは、開閉・切り替えと、開いていないときに中身が見えないことを確認します。

## 26.11 アンチパターン

- <strong>モーダルの乱用</strong>。何でもモーダルにすると、URL が機能しなくなり、戻る操作も効かなくなります。
- <strong>`<div>` で自作してキーボード操作が壊れる</strong>。focus trap や Esc を自前で作ると、抜けが出ます。`<dialog>` を使います。
- <strong>Stimulus でサーバー内容を二重管理する</strong>。サーバーから取れる内容を、Stimulus 側でも持とうとすると、ずれます。サーバー内容が要るなら Frames / Streams に任せます。

> 第26章では、サーバー内容の要否で UI の作り方を仕分けました。次の第27章では、通知・トースト・フラッシュを題材に、Turbo Streams・Stimulus・Action Cable の合わせ技で第7部を締めます。

## 参考資料

- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
- Turbo Streams リファレンス: <https://turbo.hotwired.dev/reference/streams>
- Stimulus リファレンス（Actions）: <https://stimulus.hotwired.dev/reference/actions>
- MDN: dialog 要素: <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog>
- ARIA Authoring Practices（Tabs / Menu / Dialog）: <https://www.w3.org/WAI/ARIA/apg/patterns/>
