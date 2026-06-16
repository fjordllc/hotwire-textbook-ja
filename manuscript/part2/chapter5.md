# 第5章 Rails アプリを作成する

## この章のねらい

第4章で決めた Relay の仕様を、実際の Rails アプリとして作ります。この章のゴールは、Hotwire のカスタマイズを一切していない「素の Rails アプリ」を、通常の CRUD が動く状態まで用意することです。

ここで作る状態が、第3部以降の出発点になります。あえて最初から Hotwire 化しないのは、「普通の Rails アプリのどこを、なぜ Hotwire で置き換えるのか」を後の章で実感するためです。

この章では、特に次の 3 点を固定します。

1. Rails 8 標準の認証ジェネレータの実行結果
2. `Project` / `Task` の CRUD と、`Comment` / `Tag` / `Tagging` をモデルだけに留める線引き
3. importmap を前提にした JavaScript 構成

> 本書のコードは Rails 8.0 以上で動作確認しています。コマンドや生成物が異なる場合は、お使いの Rails のバージョンを確認してください。

## 5.1 Rails アプリの作成

アプリを作成します。

```bash
rails new relay
cd relay
```

Rails 8 では、`rails new` の既定構成に本書で必要なものがそろっています。

- データベースは SQLite（学習用としてはこのままで十分です）
- JavaScript は import maps（ビルド工程が不要。Rails の既定です）
- Hotwire（`turbo-rails` と `stimulus-rails`）が `Gemfile` に最初から入っている

これらは生成されたアプリの実物で確認できます。`Gemfile` に `turbo-rails` と `stimulus-rails` が含まれ、`config/importmap.rb` と `app/javascript/application.js` が生成されています。中身の読み解きは第6章で行いますが、ここでは「追加のオプションを付けなくても、Hotwire を学ぶ準備が整っている」とだけ押さえれば十分です。

スタイルについては、本書は特定の CSS フレームワークに依存しません。見た目は最小限に留め、Hotwire の挙動に集中します。

サーバーを起動して、初期画面が出ることを確認します。

```bash
bin/rails server
```

ブラウザで `http://localhost:3000` を開き、Rails の初期ページが表示されれば成功です。

## 5.2 認証の追加

Relay では、担当者・コメント投稿者・リアルタイム更新の配信範囲を決めるために `current_user` が必要です。そこで、Rails 8 標準の認証ジェネレータを使います。

```bash
bin/rails generate authentication
bin/rails db:migrate
```

このジェネレータは、`User` と `Session` を中心に、認証に必要な一式（コントローラ・ビュー・ルーティング・マイグレーション・`bcrypt` の導入）をまとめて生成します。これで、認証（ログイン・ログアウト）とパスワード再設定の土台が入ります。ただし、パスワード再設定メールを実際に届けるには、別途メール送信（Action Mailer）の設定が必要です。本書ではメール配信そのものは扱わず、ログインを使います。

ここで 1 つ、初級者がつまずきやすい点があります。<strong>このジェネレータが作るのはログイン機能であって、サインアップ（ユーザー登録）画面ではありません。</strong>本書では、ユーザーは後述の seed データで作成し、その認証情報でログインします。

次に、第4章で決めたとおり `User` に `name` を追加します。生成直後の `User` は `email_address` と `password_digest` を持ちますが、`name` は持たないためです。

```bash
bin/rails generate migration AddNameToUsers name:string
bin/rails db:migrate
```

## 5.3 モデルの作成

第4章のモデル構成に沿って、Relay のモデルを作ります。ここでポイントになるのが、<strong>CRUD 画面まで作るモデルと、モデルだけ用意するモデルを分ける</strong>ことです。その線引きは 5.4 と 5.5 で扱います。

まず、各モデルの関連を確認しておきます。生成後に、次の関連を各モデルへ書き加えます。

`app/models/project.rb`

```ruby
class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
end
```

`app/models/task.rb`

```ruby
class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  enum :status, { todo: 0, in_progress: 1, done: 2 }, default: :todo

  validates :title, presence: true
end
```

`status` は第4章で決めたとおり enum にします。`todo` / `in_progress` / `done` の 3 状態が、後の検索・絞り込み・バリデーション・通知すべての軸になります。担当者（`assignee`）は未割り当てを許すため `optional: true` にします。

`User` にも、担当しているタスクとコメントの関連を加えます。認証ジェネレータが生成した行はそのまま残し、クラスの中に次の 2 行を追記します。

`app/models/user.rb`

```ruby
class User < ApplicationRecord
  # 認証ジェネレータが生成した内容（has_secure_password など）はそのまま残します

  # ↓ 次の 2 行を追記します
  has_many :assigned_tasks, class_name: "Task", foreign_key: :assignee_id, dependent: :nullify
  has_many :comments, dependent: :destroy
end
```

## 5.4 通常 CRUD の生成（`Project` と `Task`）

`Project` と `Task` は、ユーザーが画面から操作するリソースです。CRUD 画面ごと作るため、scaffold を使います。

```bash
bin/rails generate scaffold Project name:string description:text
bin/rails generate scaffold Task project:references title:string description:text status:integer due_on:date assignee:references
```

ここで、2 つの参照の扱いが違う点に注意します。`project` は「タスクは必ずどれかのプロジェクトに属する」ため、必須の参照のままで構いません。一方 `assignee` は「担当者は未割り当てもありうる」うえに、`assignees` テーブルではなく `User` を指す必要があります。

そこで `assignee` の参照だけを直します。生成されたマイグレーションは、そのままでは `assignees` テーブルを参照しようとし、かつ必須になります。`User` を参照し、未割り当てを許すように直します。

`db/migrate/xxxxxx_create_tasks.rb`（該当行を修正）

```ruby
      t.references :assignee, null: true, foreign_key: { to_table: :users }
```

マイグレーションを実行します。

```bash
bin/rails db:migrate
```

これで、`Project` と `Task` の一覧・詳細・作成・編集・削除が動くようになります。scaffold が生成したビューは、Rails 8 では最初から Turbo に対応した形になっています。この事実は 5.10 で確認します。

## 5.5 `Comment` / `Tag` / `Tagging` はモデルだけ用意する

`Comment`・`Tag`・`Tagging` は、第4章で「入れるが UI は後の章で作る」と決めたものです。ここでは scaffold ではなく `model` ジェネレータを使い、<strong>モデルとマイグレーションだけ</strong>を作ります。コントローラもビューも作りません。

```bash
bin/rails generate model Comment task:references user:references body:text
bin/rails generate model Tag name:string
bin/rails generate model Tagging task:references tag:references
bin/rails db:migrate
```

関連を書き加えます。

`app/models/comment.rb`

```ruby
class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :body, presence: true
end
```

`app/models/tag.rb` と `app/models/tagging.rb`

```ruby
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings
end

class Tagging < ApplicationRecord
  belongs_to :task
  belongs_to :tag
end
```

ここで UI を作り込まないのは、意図的な線引きです。コメントは第16章（Turbo Streams）で、タグは第23章（検索と絞り込み）で、それぞれ「必要になったから足す」形で UI を作ります。そうすることで、各機能を使う動機が明確になります。

## 5.6 seed データ

検索やページネーションを後の章で体感するには、ある程度の件数が必要です。seed データを用意します。ログイン用のユーザーも、ここで作ります。

seed は、何度実行しても同じ結果になるように書きます。先頭でドメインデータを消してから作り直し、ログイン用のユーザーは `find_or_create_by!` で重複を避けます。こうしておくと、`bin/rails db:seed` を繰り返しても失敗しません。

`db/seeds.rb`

```ruby
# 再実行できるように、ドメインデータを子から順に消してから作り直します
[Tagging, Comment, Task, Tag, Project].each(&:delete_all)

user = User.find_or_create_by!(email_address: "alice@example.com") do |u|
  u.name = "Alice"
  u.password = "password"
end

tags = %w[bug feature chore urgent].map { |name| Tag.create!(name: name) }

3.times do |i|
  project = Project.create!(name: "プロジェクト #{i + 1}", description: "サンプルプロジェクトです。")

  50.times do |n|
    task = project.tasks.create!(
      title: "タスク #{i + 1}-#{n + 1}",
      description: "サンプルのタスクです。",
      status: Task.statuses.keys.sample,
      assignee: [user, nil].sample,
      due_on: Date.current + rand(0..30)
    )
    task.tags << tags.sample(rand(0..2))
    task.comments.create!(user: user, body: "最初のコメントです。") if n.even?
  end
end
```

投入します。

```bash
bin/rails db:seed
```

これで、プロジェクト 3 件・タスク約 150 件・数種のタグ・散在するコメントが入ります。ページネーション（第24章）や検索（第23章）を体感できる件数です。

## 5.7 System Test の準備

Hotwire の動きは、画面を実際に操作して確かめるのが確実です。Rails の System Test を使えるようにしておきます。

Rails 8 では `rails new` の時点で System Test の足場（Capybara とヘッドレスブラウザの設定）が用意されています。最初のテストとして、プロジェクト一覧が表示されることを確認する小さなテストを書きます。

`test/system/projects_test.rb`

```ruby
require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  test "プロジェクト一覧が表示される" do
    visit projects_path
    assert_selector "h1", text: "Projects"
  end
end
```

実行します。

```bash
bin/rails test:system
```

## 5.8 最初の動作確認

ここまでの状態を、ブラウザで通して確認します。

1. `bin/rails server` でサーバーを起動する
2. `http://localhost:3000/session/new` を開き、`alice@example.com` / `password` でログインする
3. `http://localhost:3000/projects` でプロジェクト一覧を見る
4. プロジェクトを作成・編集・削除する
5. タスクを作成し、無効な入力（タイトル空）でバリデーションエラーが出ることを確認する

この時点では、まだ Hotwire のカスタマイズを何もしていません。それでも、画面遷移やフォーム送信は動きます。

## 5.9 各部のハンズオンで使うテスト方針

本書では、機能を Hotwire 化するたびに、その章で小さな System Test を 1 〜 2 本書きます。たとえば、インライン編集（第12章）、Turbo Streams での作成・削除（第16章）、検索（第23章）などです。

これらの小さなテストは、第8部「Hotwire アプリを保守する」で、テスト戦略として束ね直します。この章では「各章でテストを書く」という方針だけ共有しておきます。

## 5.10 通常 CRUD の時点で Turbo Drive が効いていることを確認する

最後に、重要な事実を確認します。<strong>ここまでで作った素の CRUD は、すでに Turbo Drive 経由で動いています。</strong>

Rails 8 では、`rails new` の時点で `turbo-rails` が読み込まれます。`app/javascript/application.js` を見ると、次のように Turbo が読み込まれているはずです。

`app/javascript/application.js`

```javascript
import "@hotwired/turbo-rails"
import "controllers"
```

ブラウザの DevTools を開き、Network タブを見ながらプロジェクト一覧のリンクをたどってみてください。ページ全体が再読み込みされず、必要な部分だけが差し替わっていることがわかります。これが Turbo Drive の働きです。

このことは、第3部の理解にとって大切です。第3部「Turbo Drive」は、新しい機能を足す章ではなく、<strong>すでに動いている仕組みを理解し、契約どおりに整える章</strong>です。その出発点が、いまできあがりました。

> この章で作った Relay は、これ以降のすべての章の土台です。モデル名・`status` の値・「コメントとタグの UI は後で作る」という線引きは、後の章で繰り返し前提になります。

## 参考資料

- Rails Guides: <https://guides.rubyonrails.org/>
- Rails ガイド「テスティング」: <https://guides.rubyonrails.org/testing.html>
- Rails ガイド「Active Record の関連付け」: <https://guides.rubyonrails.org/association_basics.html>
- Rails セキュリティガイド（認証）: <https://guides.rubyonrails.org/security.html>
