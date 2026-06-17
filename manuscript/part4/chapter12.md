# 第12章 一覧、詳細、編集フォームを Frame 化する

## この章のねらい

第11章で、Turbo Frames の基本（`id` の一致、frame 内のリンクとフォーム）を学びました。この章では、それを Relay の実際の画面に当てはめます。

作るのは<strong>インライン編集</strong>です。タスク一覧の 1 行で「編集」を押すと、その行だけがフォームに変わり、保存すると表示に戻ります。失敗したら、その行の中にエラーが出ます。ページ遷移は一切起きません。

第11章で学んだ「frame 内フォームの 303 / 422 契約」が、ここで実際に動きます。

## 12.1 一覧行を frame にする

まず、タスク一覧の各行を frame にします。第5章の scaffold が生成した `_task` partial を、`turbo_frame_tag` で囲みます。

変更前（scaffold が生成したままの `_task`）:

`app/views/tasks/_task.html.erb`

```erb
<div id="<%= dom_id task %>">
  <p><%= task.title %></p>
  <p><%= task.status %></p>
  <%= link_to "編集", edit_task_path(task) %>
</div>
```

変更後（frame で囲む）:

`app/views/tasks/_task.html.erb`

```erb
<%= turbo_frame_tag task do %>
  <p><%= task.title %></p>
  <p><%= task.status %></p>
  <%= link_to "編集", edit_task_path(task) %>
<% end %>
```

`turbo_frame_tag task` は、`dom_id(task)` を使って `id="task_1"` のような frame を生成します（第11章で見た `turbo_frame_tag dom_id(task)` の短い書き方です）。

これで、一覧の各行がそれぞれ独立した frame になりました。一覧は `<%= render @tasks %>` でこの partial を繰り返し描画するので、行ごとに `task_1`、`task_2`… という frame が並びます。

## 12.2 詳細を frame にする

詳細画面（`show`）も、同じ partial を使うようにします。こうすると、一覧と詳細で「タスク 1 件の表示」を共通化できます。

`app/views/tasks/show.html.erb`

```erb
<%= render @task %>
```

`render @task` は、いま作った `_task` partial を描画します。つまり、詳細画面も `id="task_1"` の frame を含むことになります。

ここが大切です。一覧の行も、詳細画面も、<strong>同じ `id` の frame で「タスク 1 件」を表示している</strong>状態になりました。第11章のルールを思い出してください。frame は `id` で対応づけられます。表示も編集も、この `id="task_1"` という同じ土俵の上で差し替え合うことになります。

## 12.3 インライン編集

いよいよ編集です。編集画面（`edit`）のフォームを、同じ `id` の frame で囲みます。

`app/views/tasks/edit.html.erb`

```erb
<%= turbo_frame_tag @task do %>
  <%= render "form", task: @task %>
<% end %>
```

これで準備が整いました。動きを追ってみます。

1. 一覧の行（frame `task_1`）の中の「編集」リンクをクリックする
2. Turbo は `edit_task_path` を取得し、その中から `id="task_1"` の frame を探す
3. `edit.html.erb` の frame（同じ `id="task_1"`）が見つかり、その中身（フォーム）で行を差し替える

結果として、その行だけが編集フォームに変わります。ほかの行も、ヘッダーも動きません。

保存するとどうなるでしょうか。ここで第8章の契約が効きます。

- 成功時: `update` はリダイレクトします（`status: :see_other`）。Turbo はリダイレクト先（詳細画面）を取得し、`id="task_1"` の frame＝表示用の `_task` を取り出して差し替えます。行が表示に戻ります。
- 失敗時: `update` は 422 で `edit` を再描画します。`id="task_1"` の frame＝エラー付きフォームが、その行に差し替わります。

`update` アクションは、第5章の scaffold が生成したままで動きます。成功時に `status: :see_other` が付いていること（第8章）が、ここで効いています。

## 12.4 キャンセル導線

編集をやめて表示に戻す導線も要ります。編集フォームの中に、詳細へ戻るリンクを置きます。

`app/views/tasks/edit.html.erb`

```erb
<%= turbo_frame_tag @task do %>
  <%= render "form", task: @task %>
  <%= link_to "キャンセル", task_path(@task) %>
<% end %>
```

このキャンセルリンクは frame `task_1` の中にあります。クリックすると、Turbo は詳細画面（`task_path`）を取得し、`id="task_1"` の frame＝表示用の `_task` を取り出して差し替えます。フォームが表示に戻ります。

保存もキャンセルも、「`id="task_1"` の frame を、表示の `_task` に戻す」という同じ動きだとわかります。frame の `id` を揃えてあるおかげで、どの導線も同じ土俵で差し替え合えるのです。

## 12.5 partial 設計

ここまでで、partial の設計が自然に決まりました。

- `_task.html.erb` … タスク 1 件の<strong>表示</strong>。frame で囲む。一覧と詳細の両方で使う
- `_form.html.erb` … タスクの<strong>フォーム</strong>。`new` と `edit` の両方で使う
- `edit.html.erb` … `_form` を frame で囲んだもの

ポイントは、表示（`_task`）を 1 か所にまとめたことです。一覧でも詳細でも、保存後の差し替えでも、同じ `_task` が使われます。もし行ごとに表示を別々に書いていたら、修正のたびにすべてを直す羽目になります。frame の `id` を軸に partial を共通化することが、Turbo Frames を使った設計の土台になります。

## 12.6 この章の System Test

インライン編集が動くことを、System Test で確認します。

`test/system/tasks_test.rb`（追記）

```ruby
test "一覧でインライン編集できる" do
  project = Project.create!(name: "テスト用プロジェクト")
  task = project.tasks.create!(title: "編集前のタイトル")

  visit tasks_path
  within "##{dom_id(task)}" do
    click_on "編集"
    fill_in "Title", with: "編集後のタイトル"
    click_on "Update Task"
  end

  assert_text "編集後のタイトル"
end
```

`within "##{dom_id(task)}"` で、対象タスクの frame の中だけに操作を絞っています。frame の中で編集リンクを押し、フォームを書き換え、保存します。最後に、更新後のタイトルが表示されていることを確認します。

ページ遷移していないこと、操作したのが 1 つの frame の中だけであること。これが、インライン編集が成立している証拠です。

> 第12章では、`id` を揃えた partial を軸に、ページ遷移のないインライン編集を作りました。次の第13章では、`src` を使った遅延読み込みと、サイドバー・タブといった画面分割のパターンを学びます。

## 参考資料

- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
- Turbo Frames リファレンス: <https://turbo.hotwired.dev/reference/frames>
- Rails ガイド「レイアウトとレンダリング」: <https://guides.rubyonrails.org/layouts_and_rendering.html>
