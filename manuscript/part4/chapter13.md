# 第13章 遅延読み込みと独立したナビゲーション

## この章のねらい

第12章では、frame の中身を「リンクやフォームの操作」で差し替えました。この章では、もう 1 つの差し替えのきっかけを学びます。`src` による<strong>遅延読み込み（lazy loading）</strong>です。

frame に `src` を与えると、その frame は自分で中身を取りに行きます。これを使うと、重い部分を後回しで読み込んだり、サイドバーやタブのように画面を分割したりできます。第12章の終わりで触れた「外枠の中に frame を置く」構成を、ここで実際に作ります。

## 13.1 lazy loading

frame に `src` 属性を与えると、frame はページに現れた時点で、その URL から中身を自動で取得します。読み込みのきっかけは `src` です。

例として、プロジェクトの詳細画面に「そのプロジェクトのタスク一覧」を遅延読み込みで表示してみます。タスク一覧は件数が多く、本体の表示を遅らせたくないからです。

まず、タスク一覧だけを返すアクションを足します。

`config/routes.rb`

```ruby
resources :projects do
  member do
    get :tasks_panel
  end
end
```

`app/controllers/projects_controller.rb`（追記）

```ruby
def tasks_panel
  @project = Project.find(params[:id])
end
```

`app/views/projects/tasks_panel.html.erb`

```erb
<%= turbo_frame_tag "project_tasks" do %>
  <%= render @project.tasks %>
<% end %>
```

そして、プロジェクト詳細に frame を置き、`src` でこのアクションを指します。

`app/views/projects/show.html.erb`（抜粋）

```erb
<h1><%= @project.name %></h1>

<%= turbo_frame_tag "project_tasks", src: tasks_panel_project_path(@project), loading: :lazy do %>
  <p>タスクを読み込んでいます…</p>
<% end %>
```

ここで、`src` と `loading: :lazy` の役割を分けて押さえます。`src` だけなら、frame はページに現れた時点で<strong>すぐに</strong>読み込みを始めます。`loading: :lazy` を足すと、読み込みのタイミングが「frame が画面に見える（スクロールで表示領域に入る）まで」遅れます。`src` が自動ロードの入口、`loading: :lazy` が遅延の条件です。

`src` 先のレスポンスには、第11章のルールどおり、同じ `id="project_tasks"` の frame が必要です。`tasks_panel.html.erb` がそれを満たしています。

プロジェクト詳細を開くと、まず本体（プロジェクト名）が即座に表示され、タスク一覧は少し遅れて frame の中に現れます。重い部分を本体の表示から切り離せました。

## 13.2 skeleton 表示

`src` 先の読み込みが終わるまで、frame には<strong>最初に書いておいた中身</strong>が表示されます。13.1 の例では「タスクを読み込んでいます…」がそれです。

この「読み込み中に見せておくもの」を、実際のレイアウトに似せた灰色の枠（skeleton、スケルトン）にすると、画面の見た目が安定します。読み込みの前後でガクッとレイアウトが変わらず、ユーザーの体感がよくなります。

```erb
<%= turbo_frame_tag "project_tasks", src: tasks_panel_project_path(@project), loading: :lazy do %>
  <div class="skeleton">
    <div class="skeleton-row"></div>
    <div class="skeleton-row"></div>
    <div class="skeleton-row"></div>
  </div>
<% end %>
```

skeleton は、読み込みが終われば本物に差し替わって消えます。frame の「最初の中身」は、そのまま読み込み中のプレースホルダになる、と理解しておけば十分です。

## 13.3 ページ内タブ

タブも、frame で作れます。タブの中身を、共通の content frame に読み込む形です。

タブのリンクに `data-turbo-frame` を付けて、中身を表示する共通の content frame を指します。

```erb
<nav>
  <%= link_to "概要", overview_project_path(@project), data: { turbo_frame: "tab_content" } %>
  <%= link_to "タスク", tasklist_project_path(@project), data: { turbo_frame: "tab_content" } %>
</nav>

<%= turbo_frame_tag "tab_content" do %>
  <p>タブを選んでください。</p>
<% end %>
```

タブのリンクをクリックすると、その行き先から `id="tab_content"` の frame が取り出され、content frame の中身が差し替わります。タブを切り替えても、ページの他の部分は動きません。

ここで大切なのは、第11章の id 一致ルールです。<strong>それぞれのタブの行き先のレスポンスに、`id="tab_content"` の frame が必要</strong>です。つまり、各タブの中身を返すアクションを用意し、そのビューを `turbo_frame_tag "tab_content"` で包みます。

`app/views/projects/overview.html.erb`（例）

```erb
<%= turbo_frame_tag "tab_content" do %>
  <p><%= @project.description %></p>
<% end %>
```

「タスク」タブのビューも同様に、中身を `id="tab_content"` の frame で包みます。content frame の `id` を軸に、どのタブも同じ枠を差し替え合う、という形です。タブの中身はクリックされたときに取得されるので、開いていないタブの中身は読み込まれません。

## 13.4 サイドバー詳細

第12章では、`show.html.erb` を `render @task` の 1 行にしていました。ここで、第12章の終わりで触れた「外枠の中に frame を置く」構成に進めます。

作るのは、左にタスク一覧、右に詳細パネルというサイドバー型の画面です。一覧の行をクリックすると、右の詳細パネルだけが切り替わります。

まず、一覧の各行のリンクに `data-turbo-frame` を付けて、詳細パネルの frame を指します。

`app/views/tasks/index.html.erb`（抜粋）

```erb
<div class="layout">
  <ul class="list">
    <% @tasks.each do |task| %>
      <li><%= link_to task.title, task_path(task), data: { turbo_frame: "detail" } %></li>
    <% end %>
  </ul>

  <%= turbo_frame_tag "detail" do %>
    <p>タスクを選んでください。</p>
  <% end %>
</div>
```

次に、`show.html.erb` を、`id="detail"` の frame で包みます。

`app/views/tasks/show.html.erb`

```erb
<%= turbo_frame_tag "detail" do %>
  <h2><%= @task.title %></h2>
  <%= render @task %>
<% end %>
```

一覧のリンクをクリックすると、Turbo は `task_path(task)` を取得し、`id="detail"` の frame を取り出して、右パネルに差し替えます。詳細の中には、第12章で作った `_task`（`id="task_1"` の frame）がそのまま入っているので、<strong>サイドバーに表示した詳細の中で、インライン編集もそのまま動きます</strong>。frame は入れ子にできるのです。

## 13.5 エラー時の表示

`src` 先やリンク先が、404 や 500 を返すこともあります。第11章で見たとおり、frame はレスポンスから同じ `id` の frame を探します。<strong>エラーのときも、レスポンスに同じ `id` の frame が含まれていないと、frame は壊れます</strong>（案内メッセージと例外）。

そのため、エラー用の画面でも、同じ `id` の frame の中にエラー表示を入れておきます。たとえば 404 のとき、`id="detail"` の frame の中に「見つかりませんでした」を描く、という形です。こうすれば、サイドバーやタブの中に、きれいにエラーが収まります。

遅延読み込みや画面分割を使うほど、「正常系だけでなく、エラーのレスポンスにも frame を用意する」ことが大切になります。

## 13.6 `<turbo-frame refresh="morph">` を使う場面

第9章で、Turbo 8 の page refresh（同じ URL への visit による再描画）を見ました。frame には、この page refresh が起きたときの振る舞いを指定できます。`refresh` 属性です。

page refresh が起きると、`src` を持つ frame は中身を読み込み直します。既定では、frame の中身がまるごと差し替わり、frame の中のスクロール位置や入力中のフォーカスが失われます。

これを避けたいときに、frame へ `refresh="morph"` を付けます。

```erb
<%= turbo_frame_tag "project_tasks", src: tasks_panel_project_path(@project), refresh: :morph do %>
  ...
<% end %>
```

`refresh: :morph` を付けると、<strong>page refresh のときの</strong> frame の再読み込みが、第9章で見た morph（差分の適用）で行われます。変わった部分だけが書き換わり、frame の中の状態が保たれます。これは一般の `src` 再取得すべてに効くのではなく、あくまで page refresh のときの振る舞いを変える指定です。

これは、第18章のリアルタイム更新と組み合わせると効きます。サーバーが「このページを refresh してください」という配信（broadcast refresh）を全員へ送ると、各自の frame が morph で最新化され、見ていた位置や入力が保たれます。

> 第13章では、`src` による遅延読み込みと、タブ・サイドバーといった画面分割を作りました。frame は入れ子にでき、組み合わせると複雑な画面も組めます。だからこそ、次の第14章では「使いすぎたときにどうなるか」と、Streams や通常遷移へ切り替える判断を扱います。

## 参考資料

- Turbo Frames（Handbook）: <https://turbo.hotwired.dev/handbook/frames>
- Turbo Frames リファレンス: <https://turbo.hotwired.dev/reference/frames>
- Page Refreshes と morphing（Handbook）: <https://turbo.hotwired.dev/handbook/page_refreshes>
