# 第8章 リンクとフォーム送信の仕組み

## この章のねらい

第7章では、リンクのクリックが visit になることを見ました。この章では、<strong>フォーム送信も同じ visit になる</strong>ことを理解します。

そして、フォーム送信では controller が返す内容に約束ごとがあります。成功したときと失敗したときで、返すべきものが決まっているのです。この約束ごとは、第5部（Turbo Streams）と第7部（フォーム UX）の土台になります。第3部の中でもっとも大切な章です。

## 8.1 GET リンクと visit

第7章で見たとおり、リンクのクリックは visit になります。リンクは HTTP の GET リクエストです。Turbo Drive は GET の遷移を横取りし、body を差し替えます。

GET は、フォームでも使えます。たとえば検索フォームは GET です。検索ボックスに入力して送信すると、`/tasks?q=...` のような URL へ GET し、その結果で body が差し替わります。これも visit です（検索は第23章で実装します）。

GET は「サーバーの状態を変えない読み取り」です。次に見る、状態を変える送信とは扱いが分かれます。

## 8.2 POST / PATCH / DELETE の送信

タスクの作成・更新・削除は、サーバーの状態を変えます。これらは GET ではなく、POST（作成）・PATCH（更新）・DELETE（削除）で送ります。

従来の Rails では、フォームを送信するとページ全体が再読み込みされていました。Turbo Drive では、フォーム送信も visit として扱われます。Turbo がフォーム送信を横取りし、バックグラウンドで送信し、返ってきた結果を画面に反映します。

ここで問題になるのが、「送信のあと、何を返すか」です。GET のリンクなら、行き先の HTML を返せば済みます。しかし、状態を変える送信では、成功する場合と失敗する場合があります。この 2 つで、返すべきものが変わります。

## 8.3 成功時は redirect

送信が成功したとき、controller は <strong>リダイレクト</strong>を返します。たとえばタスクを作成できたら、作成したタスクの詳細ページへリダイレクトします。

Relay の `Task` は scaffold で作ったので、`create` はすでにこの形になっています。

`app/controllers/tasks_controller.rb`（`create` の一部）

```ruby
if @task.save
  redirect_to @task, notice: "Task was successfully created."
else
  render :new, status: :unprocessable_entity
end
```

成功時に `redirect_to` を返すと、Turbo はそのリダイレクト先へ visit します。結果として、作成したタスクの詳細ページへ画面が切り替わります。

更新（`update`）と削除（`destroy`）のリダイレクトには、もう 1 つ指定が付きます。

`app/controllers/tasks_controller.rb`（`update` と `destroy` の一部）

```ruby
# update
redirect_to @task, notice: "Task was successfully updated.", status: :see_other

# destroy
redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other
```

`status: :see_other` は HTTP の 303 です。これは「この場所を GET で見に行ってください」という意味のリダイレクトです。

なぜ更新と削除にだけ付けるのでしょうか。PATCH や DELETE で送信したあと、Turbo はリダイレクトを追いかけます。このとき 303 を返すと、リダイレクト先を確実に GET で取得します。これがないと、リダイレクト先を元のメソッド（PATCH や DELETE）で取得しようとして、意図しない動きになることがあります。だから Rails の scaffold は、`update` と `destroy` のリダイレクトに `status: :see_other` を付けています。

## 8.4 失敗時は 422 でフォームを再描画する

送信が失敗したとき、たとえばタスクのタイトルが空でバリデーションに引っかかったときは、リダイレクトしません。<strong>入力中のフォームを、エラー付きで返します。</strong>

このとき大切なのが、HTTP ステータスです。8.3 のコードの失敗側を、もう一度見ます。

```ruby
else
  render :new, status: :unprocessable_entity
end
```

`render :new` でフォームを描き直し、`status: :unprocessable_entity`（HTTP の 422）を付けています。

Turbo は、422 で返ってきたフォームの HTML で、いまの body を差し替えます。その結果、ページ遷移せずに、入力した内容とエラーメッセージがその場に表示されます。ユーザーは、入力をやり直せます。

> 本書では、このステータスをコードで書くときは `status: :unprocessable_entity` を使います。HTTP のステータス名としては「422」と表記します。

## 8.5 status code は Turbo との契約

ここまでをまとめると、状態を変えるフォーム送信には、はっきりした約束ごとがあります。

- 成功したら、リダイレクトを返す（更新・削除は 303）
- 失敗したら、フォームを 422 で返す

この約束ごとを、本書では <strong>Turbo との契約</strong>と呼びます。Turbo は、フォーム送信の結果がリダイレクトなら visit し、422 ならその HTML で body を差し替える、という前提で動いているからです。

逆に、この契約を外すと動きません。よくあるつまずきは、失敗時に 422 ではなく 200 でフォームを返してしまうことです。すると Turbo はそれをエラーの再描画とみなさず、画面が更新されません。「フォームを送ったのに、エラーが出ない・画面も変わらない」という症状になります。

この契約は、第25章「バリデーションエラーとフォーム UX」で本格的に使います。ここでは「成功は redirect、失敗は 422」という対応を覚えておいてください。

## 8.6 この章の System Test

契約どおりに動いているかを、System Test で確かめます。Relay のタスク作成について、成功と失敗の 2 つを書きます。

第5章ではタスクをフラットな scaffold で作ったので、作成画面は `new_task_path` です。タスクには所属プロジェクトが必要なので、テストの中で先に用意します。

`test/system/tasks_test.rb`

```ruby
require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @project = Project.create!(name: "テスト用プロジェクト")
  end

  test "タスクを作成すると遷移して成功メッセージが出る" do
    visit new_task_path
    fill_in "Title", with: "最初のタスク"
    fill_in "Project", with: @project.id
    click_on "Create Task"

    assert_text "Task was successfully created"
  end

  test "タイトルが空だと同じ画面にエラーが出る" do
    visit new_task_path
    fill_in "Title", with: ""
    fill_in "Project", with: @project.id
    click_on "Create Task"

    assert_text "prohibited this task from being saved"
  end
end
```

1 つ目は成功のケースです。リダイレクトが起き、成功メッセージが表示されることを確認します。2 つ目は失敗のケースです。422 でフォームが差し替わり、エラー表示が出ることを確認します。ページ遷移していないことが、この契約の肝です。

> フォームの項目名（`Title`、`Project` など）や成功・エラーの文言は、scaffold が生成したビューに由来します。生成された画面に合わせて読み替えてください。

実行します。

```bash
bin/rails test:system
```

> 第8章では、フォーム送信も visit であり、成功は redirect、失敗は 422 という契約があることを見ました。次の第9章では、visit を速く見せるキャッシュと、Turbo 8 の morphing を扱います。

## 参考資料

- Turbo Drive（Handbook）: <https://turbo.hotwired.dev/handbook/drive>
- Turbo の属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
- Rails ガイド「レイアウトとレンダリング」: <https://guides.rubyonrails.org/layouts_and_rendering.html>
