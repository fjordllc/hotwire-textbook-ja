# FBC Press: Hotwire 詳細目次（節レベル）

各章は「ねらい」→「節構成」→「主な参考資料（候補）」で示します。参考 URL は執筆時に実在確認のうえ各章末へ掲載します。

## このページ内の案内

- [第1部 Hotwire を理解する](#outline-part1)
- [第2部 ハンズオンの準備](#outline-part2)
- [第3部 Turbo Drive](#outline-part3)
- [第4部 Turbo Frames](#outline-part4)
- [第5部 Turbo Streams](#outline-part5)
- [第6部 Stimulus](#outline-part6)
- [第7部 実務で使う Hotwire UI パターン](#outline-part7)
- [第8部 Hotwire アプリを保守する](#outline-part8)
- [第9部 Hotwire Native](#outline-part9)
- [第10部 Hotwire を選ぶべきか](#outline-part10)
- [付録](#outline-appendix)

---

<a id="outline-part1"></a>
# 第1部 Hotwire を理解する

## 第1章 Hotwire とは何か
**ねらい:** Hotwire を「Rails の便利機能」ではなく、HTML over the wire という設計思想として理解する。

- 1.1 Hotwire の全体像
- 1.2 Turbo / Stimulus / Native の役割
- 1.3 JSON API + SPA との違い
- 1.4 Rails に標準で入っている意味
- 1.5 本書で作るサンプルアプリの見取り図
- ◎ <https://hotwired.dev/>

## 第2章 HTML over the wire という考え方
**ねらい:** サーバーで HTML を生成して送る設計が、なぜ現代的な選択肢として戻ってきたのかを理解する。

- 2.1 Web アプリケーションの画面更新の歴史
- 2.2 Ajax と JSON API の普及
- 2.3 SPA が解決したこと、増やしたこと
- 2.4 HTML を送ることの再評価
- 2.5 Hotwire が向くアプリケーション
- ◎ <https://turbo.hotwired.dev/>

## 第3章 なぜ Rails と Hotwire は相性がよいのか
**ねらい:** Rails の MVC、REST、partial、Action Cable と Hotwire の接続点を整理する。

- 3.1 Rails はもともと HTML を返すフレームワークである
- 3.2 partial と Turbo の相性
- 3.3 RESTful controller と Turbo Streams
- 3.4 Action Cable とリアルタイム更新
- 3.5 Hotwire を使うときの Rails 設計の変化
- ◎ <https://guides.rubyonrails.org/>

---

<a id="outline-part2"></a>
# 第2部 ハンズオンの準備

この部では、本書を通して育てるサンプルアプリを確定します。題材は、チーム向けタスク管理アプリ **Relay** とします。プロジェクトの下にタスクがぶら下がり、タスクにステータス、担当者、タグ、コメントが付きます。

Relay を採用する理由は、第7部の実務 UI パターンを 1 つの自然なドメインで扱えるからです。一覧と検索、件数の多いデータ、ステータス遷移、バリデーション、コメント、複数ユーザーへのリアルタイム通知を無理なく入れられます。スコープの線引き（本書でやること / やらないこと）は、第4章 4.3 にまとめます。

## 第4章 サンプルアプリの仕様
**ねらい:** これから育てるアプリ Relay の全体像を共有し、どの画面をどの Hotwire 技術で作るかの地図を渡す。

- 4.1 題材の選定: チーム向けタスク管理に決めた理由
- 4.2 題材に必要な条件: 一覧＋検索、件数、ステータス遷移、複数ユーザー
- 4.3 本書でやること / やらないこと（スコープの線引き）
- 4.4 モデル構成
- 4.5 主要画面
- 4.6 Hotwire 化するポイント
- 4.7 各部との機能対応表（どの部で Relay の何を作る / 変えるか。第7部の章別内訳は第7部の各章で詳述）
- 4.8 完成形の操作ストーリー（ユーザーが Relay をどう操作するか、画面の流れで示す）
- 4.9 本書で採用する JavaScript 構成（importmap を基本にする）
- ○ <https://guides.rubyonrails.org/>

### 本書でやること / やらないこと（4.3）

| 要素 | 本編での扱い | 理由 |
| --- | --- | --- |
| 認証 | 入れる（最小） | `current_user` が担当者、コメント投稿者、broadcast 範囲に必要になるため。Rails 標準の認証機能を使う。 |
| 認可 | 本編は最小、深掘りは第31章 | 単一チーム前提にして、Pundit などの認可ライブラリは持ち込まない。 |
| マルチテナント / メンバー管理 | 入れない | Membership を入れると認可が重くなるため。1 チーム全員が同じプロジェクトを見られる前提にする。 |
| タグ | 入れる（第23章で UI 化） | 検索と絞り込みに必要。初期 CRUD ではなく、必要になった章で導入する。 |
| 担当者 | 入れる | 実務的なフィルタ、表示、broadcast の文脈に必要。`Task` から `User` への nullable 参照に留める。 |
| コメント | 入れる（UI は第16章以降） | Turbo Streams とリアルタイム更新の主役。モデルは第5章で用意し、UI は後で育てる。 |
| 通知 | 永続化しない | 本編では Action Cable による即時通知に限定する。永続 `Notification` モデルは付録候補にする。 |

### モデル構成（4.4）

| モデル | 主な属性 | 役割 |
| --- | --- | --- |
| `User` | `name`, `email_address`, `password_digest` | ログインユーザー、担当者、コメント投稿者 |
| `Project` | `name`, `description` | タスクをまとめる単位 |
| `Task` | `project_id`, `title`, `description`, `status`, `assignee_id`, `due_on` | 本書の中心リソース |
| `Comment` | `task_id`, `user_id`, `body` | Streams と broadcast の題材 |
| `Tag` | `name` | 検索・絞り込みの題材 |
| `Tagging` | `task_id`, `tag_id` | `Task` と `Tag` の中間モデル |

`Task#status` は `todo`、`in_progress`、`done` の enum にします。ステータスは検索、絞り込み、バリデーション、表示切り替え、通知のすべてに使えるため、本書のハンズオンを支える軸になります。

なお `User` は Rails 標準の認証ジェネレータで作ります。生成直後の `User` は `email_address` と `password_digest` のみを持ち、`name` は含みません。本書では生成後に `name` を追加します。あわせて認証用の `Session` モデルが生成されますが、これは認証インフラであり、上表のドメインモデルには含めません。

### 主要画面（4.5）

| 画面 | 役割 | 主に使う技術 |
| --- | --- | --- |
| プロジェクト一覧 / 詳細 | 入口、通常のページ遷移の題材 | Turbo Drive |
| タスク一覧（リスト / ボード） | 検索、絞り込み、ページネーション | Turbo Frames + Stimulus |
| タスク詳細（サイドバー） | 遅延読み込み、タブ | Turbo Frames |
| タスク作成 / 編集 | バリデーション UX、モーダル | Frames + Streams + Stimulus |
| コメント欄 | 追記、削除、リアルタイム更新 | Turbo Streams + Action Cable |
| 通知トースト / flash | 操作結果、他者の更新 | Streams + Stimulus + Action Cable |

### 各部との機能対応表（4.7）

| 部 | Relay で作る / 変える対象 | 主な技術 |
| --- | --- | --- |
| 第3部 Turbo Drive | プロジェクト / タスクのページ遷移とフォーム送信 | Turbo Drive |
| 第4部 Turbo Frames | タスクのインライン編集、サイドバー詳細の遅延読み込み | Turbo Frames |
| 第5部 Turbo Streams | コメント追記・削除、タスクの作成・更新・削除、件数更新、Cable 配信 | Turbo Streams + Action Cable |
| 第6部 Stimulus | タスクフォームの補助、ドロップダウン、文字数、確認 UI | Stimulus |
| 第7部 UI パターン | タスクの検索・絞り込み、ページネーション、フォーム UX、モーダル / タブ / ドロップダウン、通知トースト | 総合 |
| 第8部 保守 | System Test、デバッグ、N+1、認可とセキュリティ | 横断 |
| 第9部 Native | Relay をネイティブシェルで包む | Hotwire Native |
| 第10部 選定 | Relay を題材にアンチパターンと SPA 比較を振り返る | 採用判断 |

## 第5章 Rails アプリを作成する
**ねらい:** Hotwire 化前の素の Rails アプリを、通常 CRUD が一通り動く状態まで用意する。

- 5.1 Rails アプリの作成（**Rails 8.0 以上**を前提、DB、CSS 方針）
- 5.2 認証の追加（Rails 標準の認証機能を使う。生成後に `User` へ `name` を追加する）
- 5.3 モデルの作成
- 5.4 通常 CRUD の生成（`Project` と `Task`）
- 5.5 `Comment`、`Tag`、`Tagging` はモデルだけ用意する
- 5.6 seed データ（プロジェクト 3 件、タスク約 150 件、タグ数種、コメント散在）
- 5.7 System Test の準備
- 5.8 最初の動作確認
- 5.9 各部のハンズオンで使うテスト方針
- 5.10 標準構成では通常 CRUD の時点で既に Turbo Drive が効いていることを確認する（`turbo-rails` が既定で入るため）
- ◎ <https://guides.rubyonrails.org/testing.html>

### 最初に作る通常 CRUD の範囲

- `Project`: 一覧、詳細、作成、編集、削除
- `Task`: プロジェクト配下の一覧、詳細、作成、編集、削除
- `Comment`: モデルと migration のみ。UI は第16章以降で作る
- `Tag`: モデルと migration のみ。UI は第23章以降で使う

コメントとタグの UI は最初に作り込みません。後の章で「必要になったから足す」流れにすると、Hotwire の各機能を使う理由が明確になります。

## 第6章 Hotwire の標準構成を確認する
**ねらい:** Hotwire 関連ファイルと読み込み経路を把握し、本書が使う JavaScript 構成を importmap に確定する。

- 6.1 `turbo-rails`
- 6.2 `stimulus-rails`
- 6.3 本書の基本構成: importmap
- 6.4 なぜ本書では importmap を主軸にするのか
- 6.5 jsbundling 構成が必要になる場面
- 6.6 第22章の外部ライブラリ連携を importmap で扱う方針
- 6.7 開発中に見るべきログとブラウザ DevTools
- ◎ <https://github.com/hotwired/turbo-rails>
- ◎ <https://github.com/hotwired/stimulus-rails>
- ○ <https://guides.rubyonrails.org/working_with_javascript_in_rails.html>

---

<a id="outline-part3"></a>
# 第3部 Turbo Drive

この部を貫く軸は「**すべては visit である**」です。Turbo Drive は、リンクもフォーム送信も visit（訪問）という同じ処理に揃えます。visit とは「HTML を取得し、`<body>` を差し替え、`<head>` をマージする」ことです。第7〜10章は、この 1 つの動作を **どの HTML で・いつ・どう差し替えるか** を制御する話として一直線に読めます。

- 第7章: visit とは何か（差し替えの基本動作）
- 第8章: フォームの結果も visit になる ― 成功は redirect、失敗は 422 render という契約
- 第9章: 差し替えを速く見せる（cache / preview）と、差し替え方を変える（morphing）
- 第10章: visit の前後に割り込む（イベント制御）

第8章の 422 は第7部（第25章）のフォーム UX へ、第9章の morphing は第5部（第18章）の broadcast refresh へつながります。

## 第7章 Turbo Drive の基本
**ねらい:** 「visit ＝ body 差し替え＋ head マージ」という Turbo Drive の心臓部を、素の遷移と比べて理解する。

- 7.1 通常のページ遷移（従来の Rails は毎回フルリロード）
- 7.2 Turbo Drive の visit と body 差し替え（visit を定義する）
- 7.3 head のマージと `data-turbo-track="reload"`（アセット更新時だけ全リロード）
- 7.4 progress bar（500ms ルール）
- 7.5 visit を無効化する（`data-turbo="false"` の局所適用）
- ◎ <https://turbo.hotwired.dev/handbook/drive>

## 第8章 リンクとフォーム送信の仕組み 〔第3部の要〕
**ねらい:** フォーム送信の結果も visit であり、成功＝redirect・失敗＝422 render が Turbo との契約だと体得する。この章が第7部（第25章）と第5部の土台になる。

- 8.1 GET リンクと visit
- 8.2 POST / PATCH / DELETE の送信
- 8.3 成功時は redirect（`update` / `destroy` は `status: :see_other`／303 を使う理由）
- 8.4 失敗時は 422 でフォームを再描画する
- 8.5 status code は Turbo との契約: 状態を変えるフォーム送信は、成功＝303 redirect・失敗＝422 render に揃える（→ 第25章で実装）
- 8.6 この章の System Test（作成成功で遷移、失敗で同画面にエラー）
- ◎ <https://turbo.hotwired.dev/handbook/drive>
- ◎ <https://turbo.hotwired.dev/reference/attributes>

## 第9章 キャッシュ、プレビュー、リロード、morphing
**ねらい:** Turbo Drive のキャッシュと Turbo 8 以降の morphing を理解し、意図しない表示を防げるようにする。

**〔キャッシュ系〕差し替えを速く見せる**
- 9.1 snapshot cache
- 9.2 preview 表示
- 9.3 `data-turbo-temporary` と `turbo-cache-control`（`no-cache` / `no-preview`）
- 9.4 `data-turbo-track` の再確認
- 9.5 キャッシュと Stimulus の関係（再接続）

**〔morphing 系〕差し替え方そのものを変える**
- 9.6 Turbo 8 の page refresh と morph
- 9.7 `<meta name="turbo-refresh-method" content="morph">`（既定は `replace`）
- 9.8 `<meta name="turbo-refresh-scroll" content="preserve">`（既定は `reset`）
- 9.9 `data-turbo-permanent` と morph の関係
- 9.10 `<turbo-stream action="refresh" method="morph" scroll="preserve">` と broadcast refresh（→ 第18章）
- ◎ <https://turbo.hotwired.dev/handbook/page_refreshes>
- ◎ <https://turbo.hotwired.dev/reference/attributes>

## 第10章 Turbo Drive のイベントと制御
**ねらい:** Turbo のイベントを観察し、必要な場面で動作を制御できるようにする。

- 10.1 visit ライフサイクルの主要イベント（click → before-visit → visit → before-render → render → load）
- 10.2 submit 前後の制御（`turbo:submit-start` / `submit-end`）
- 10.3 visit の制御（`turbo:before-visit` で中断、`Turbo.visit()` でプログラム遷移）
- 10.4 確認ダイアログとローディング表示（`data-turbo-confirm` ／ progress 連動）
- 10.5 デバッグ用イベントログ（→ 第29章へ橋渡し）
- 10.6 `turbo:morph` 系イベントを観察する
- ◎ <https://turbo.hotwired.dev/reference/events>

---

<a id="outline-part4"></a>
# 第4部 Turbo Frames

この部を貫く軸は「**frame は独立した小さな visit 領域である**」です。第3部の visit が `<body>` 全体の差し替えなら、Turbo Frame は `<turbo-frame>` 単位の差し替えです。frame 内のリンク・フォームは、ページ全体ではなく frame の中だけを差し替えます。第11〜14章は「frame の中だけを差し替える」という 1 動作を、基本 → CRUD 化 → 遅延読み込み → 使いすぎの見切り、と育てていきます。

## 第11章 Turbo Frames の基本
**ねらい:** 「frame ＝独立した visit 領域」を理解し、frame 内のリンク・フォームが frame 内だけを置換する挙動を体感する。

- 11.1 Turbo Frames とは（visit のスコープを frame に絞る）
- 11.2 `turbo_frame_tag` と id の一致ルール（レスポンス側にも同じ id が要る）
- 11.3 frame 内リンク
- 11.4 frame 内フォーム
- 11.5 `data-turbo-frame` で外側／別 frame を target する
- ◎ <https://turbo.hotwired.dev/handbook/frames>
- ◎ <https://turbo.hotwired.dev/reference/frames>

## 第12章 一覧、詳細、編集フォームを Frame 化する
**ねらい:** CRUD 画面を部分更新に向いた形へ段階的に変える。

- 12.1 一覧行を frame にする
- 12.2 詳細を frame にする
- 12.3 インライン編集
- 12.4 キャンセル導線
- 12.5 partial 設計
- 12.6 この章の System Test
- ◎ <https://turbo.hotwired.dev/reference/frames>

## 第13章 遅延読み込みと独立したナビゲーション
**ねらい:** `src` を使った遅延読み込みと、画面分割の実務パターンを学ぶ。

- 13.1 lazy loading
- 13.2 skeleton 表示
- 13.3 ページ内タブ
- 13.4 サイドバー詳細
- 13.5 エラー時の表示
- 13.6 `<turbo-frame refresh="morph">` を使う場面（→第9章と接続）
- ◎ <https://turbo.hotwired.dev/handbook/frames>
- ◎ <https://turbo.hotwired.dev/handbook/page_refreshes>

## 第14章 Frames の失敗パターンと設計判断
**ねらい:** Frames を使いすぎたときの複雑さを見抜き、Streams や通常遷移へ切り替える判断軸を持つ。第5部への橋渡しとなる章。

- 14.1 frame の入れ子が深くなる兆候
- 14.2 URL と画面状態のズレ（frame 内遷移は URL に出ない）
- 14.3 controller が frame 分岐だらけになる兆候
- 14.4 Streams へ切り替える判断（複数箇所の更新が要るなら frame をやめる）
- 14.5 通常遷移に戻す判断（独立性が不要なら frame をやめる）
- ○ <https://turbo.hotwired.dev/handbook/frames>

---

<a id="outline-part5"></a>
# 第5部 Turbo Streams

この部を貫く軸は「**Streams は差し替え命令の入った HTML を送る**」です。第3部の body visit、第4部の frame visit が「1 か所をまるごと差し替える」のに対し、Turbo Streams は「どの id に・どの action を・どの HTML で」適用するかを書いた命令を送り、**複数の場所を別々の action で同時に操作**できます。第15〜18章は、この命令を「1 つ書く → CRUD に流す → 複数同時に束ねる → 他者へ配信する」と広げます。第4部14.4「複数箇所の更新が要るなら frame をやめる」が、この部の入口です。

## 第15章 Turbo Streams の基本
**ねらい:** 「target id ＋ action ＋ HTML」という stream 命令の構造を理解し、frame との違い（差し替えではなく命令）を掴む。

- 15.1 Turbo Streams とは（frame との違い）
- 15.2 8 つの action（append / prepend / replace / update / remove / before / after / refresh）
- 15.3 target（単一 id）と targets（CSS セレクタで複数）
- 15.4 `turbo_stream.erb` と `format.turbo_stream`
- 15.5 MIME type（`text/vnd.turbo-stream.html`）と、なぜ POST 応答で効くか
- 15.6 refresh action の使いどころ（page refresh を誘発、→ 第9章 morphing と接続）
- ◎ <https://turbo.hotwired.dev/handbook/streams>
- ◎ <https://turbo.hotwired.dev/reference/streams>

## 第16章 create / update / destroy を Stream 化する
**ねらい:** Rails の CRUD 操作を画面遷移なしで更新する。

- 16.1 create 後に prepend する
- 16.2 update 後に replace する
- 16.3 destroy 後に remove する
- 16.4 flash を更新する
- 16.5 エラー時はフォームを差し替える
- 16.6 この章の System Test
- ◎ <https://turbo.hotwired.dev/reference/streams>

## 第17章 複数箇所を同時に更新する
**ねらい:** 一覧、件数、flash など複数箇所を一度に更新する設計を学ぶ。

- 17.1 1 レスポンスに複数 stream を含める
- 17.2 カウンター更新
- 17.3 空状態の表示
- 17.4 partial の共通化
- 17.5 id 設計と `dom_id`（`dom_id(task)` が stream target の基盤になる）
- 17.6 アクセシブルな更新通知の入口
- ◎ <https://turbo.hotwired.dev/reference/streams>
- ◎ <https://turbo.hotwired.dev/reference/attributes>

## 第18章 Action Cable でリアルタイム更新する
**ねらい:** 複数ユーザーに同じ更新を配信する仕組みを理解する。

- 18.1 broadcast の基本（`turbo_stream_from` で購読する）
- 18.2 model callback と broadcast（`broadcasts_to` / `broadcast_append_to` など）
- 18.3 controller からの broadcast
- 18.4 配信範囲の設計
- 18.5 認可の入口（配信先の制御は controller / model 側。詳細は第31章）
- 18.6 実務での注意点
- ◎ <https://guides.rubyonrails.org/action_cable_overview.html>
- ◎ <https://turbo.hotwired.dev/handbook/streams>

---

<a id="outline-part6"></a>
# 第6部 Stimulus

この部を貫く軸は「**Stimulus は HTML に振る舞いを足す。状態は HTML に置く**」です。第3〜5 部はサーバが HTML を送って差し替える話でしたが、第6部はその補完です。Stimulus はサーバ往復が要らない振る舞いだけを HTML に足し、状態は JS の中ではなく HTML 側（data 属性）に持ちます。だから Turbo がページや frame を差し替えても、controller は HTML を見て自分を再構成できます。第19〜22章は「接続する → 操作する → 状態を HTML に持たせる → 外部ライブラリの生死を管理する」と進みます。第7部（第26章）の「サーバの状態が要るか」という問いの、答えの片側を担う部です。

## 第19章 Stimulus の基本
**ねらい:** Stimulus を「HTML に振る舞いを足す小さな JS」として理解する。

- 19.1 Stimulus の思想
- 19.2 controller
- 19.3 data 属性
- 19.4 Rails での配置
- 19.5 Turbo との関係
- ◎ <https://stimulus.hotwired.dev/handbook/introduction>

## 第20章 Controller / Action / Target
**ねらい:** Stimulus の中心概念を手を動かして覚える。

- 20.1 controller の作成
- 20.2 action の接続
- 20.3 target の参照
- 20.4 複数 target
- 20.5 よくある命名ミス
- 20.6 この章の System Test
- ◎ <https://stimulus.hotwired.dev/reference/controllers>
- ◎ <https://stimulus.hotwired.dev/reference/actions>
- ◎ <https://stimulus.hotwired.dev/reference/targets>

## 第21章 Values / Classes / Outlets
**ねらい:** controller に設定値や外部 controller との接続を持たせる方法を学ぶ。

- 21.1 Values
- 21.2 CSS Classes
- 21.3 Outlets
- 21.4 状態を持つべきかの判断
- 21.5 HTML 側に情報を置く利点
- ◎ <https://stimulus.hotwired.dev/reference/values>
- ◎ <https://stimulus.hotwired.dev/reference/css-classes>
- ◎ <https://stimulus.hotwired.dev/reference/outlets>

## 第22章 外部ライブラリと連携する
**ねらい:** Stimulus から外部 JS ライブラリを安全に初期化・破棄する。

- 22.1 connect / disconnect でライフサイクルに合わせる
- 22.2 動的 DOM と再接続
- 22.3 chart / date picker の例
- 22.4 cleanup（disconnect で破棄、`turbo:before-cache` で後始末）
- 22.5 Turbo cache との相互作用（→第9章9.5）
- 22.6 importmap での外部ライブラリ読み込み（→第6章6.6）
- ◎ <https://stimulus.hotwired.dev/reference/lifecycle-callbacks>
- ◎ <https://turbo.hotwired.dev/reference/events>

---

<a id="outline-part7"></a>
# 第7部 実務で使う Hotwire UI パターン

この部では、実務で頻出する UI を題材にして、Hotwire の使い分けを体得します。各章では次の 3 つの問いを使い回します。

| 問い | 答えが指す技術 |
| --- | --- |
| サーバーの状態（DB・認可）が要るか？ | 要る → Turbo Frames / Turbo Streams、不要 → Stimulus 単独 |
| 更新する場所は 1 か所か、複数か？ | 1 か所 → Turbo Frames、複数同時 → Turbo Streams |
| きっかけは誰か？ | 自分の操作 → Frames / Streams、他者・サーバー発 → Action Cable broadcast |

**第8部との役割分担:** 第7部の各章で扱う a11y とテストは、「その UI を作るうえで最低限その場で確認する」局所的・実装密着のものに留めます。それらを横断的に束ねる **テスト戦略（第28章）と観察ツールの体系化（第29章）は第8部** で扱います。第7部は「作る」、第8部は「束ねて守る」と切り分けて読んでください。

## 横断コラム: Frames か Streams か Stimulus か
**ねらい:** 第7部で使う判断軸を 1 ページの早見表として提示する。

- サーバー状態が不要なら Stimulus 単独
- 1 か所だけをサーバーから差し替えるなら Turbo Frames
- 複数箇所を同時に更新するなら Turbo Streams
- 他者やサーバー起点の更新なら Action Cable broadcast
- 「できる」ではなく「読みやすく保てる」を判断基準にする

## 第23章 検索と絞り込み
**ねらい:** 入力に追従して一覧だけが絞り込まれ、かつ URL で共有・リロードできる検索を作る。Turbo Frames が「1 か所更新」の代表例だと体得する。

- 23.1 完成イメージ: 検索ボックス、ステータス、タグ絞り込み、URL 共有
- 23.2 この章の選択: 一覧 1 か所の差し替えなので Turbo Frames
- 23.3 通常の GET 検索（全ページリロード）を作る
- 23.4 一覧を `turbo_frame_tag` で囲み、結果だけ差し替える
- 23.5 Stimulus で `requestSubmit()` を debounce する
- 23.6 `data-turbo-action="advance"` で履歴に積む
- 23.7 フレーム外の件数バッジを更新したくなったときの Streams 判断
- 23.8 a11y: `aria-live="polite"`、件数の読み上げ、フォーカス保持
- 23.9 テスト: System Test と Request Test の分担
- 23.10 アンチパターン: debounce なし、URL 共有不能、単一箇所なのに Streams で全置換
- ◎ <https://turbo.hotwired.dev/handbook/frames>
- ◎ <https://turbo.hotwired.dev/reference/attributes>
- ◎ <https://stimulus.hotwired.dev/reference/actions>

## 第24章 ページネーションと無限スクロール
**ねらい:** 「もっと読む」を土台に、無限スクロールを上乗せとして実装する。安易な無限スクロールの代償を知る。

- 24.1 完成イメージ: ページ送り、もっと読む、無限スクロールの 3 段階
- 24.2 この章の選択: 置換は Frames、追記は Streams、検知は Stimulus に割り振る
- 24.3 通常のページネーションを作る
- 24.4 Frame 内ページネーションと `data-turbo-action`
- 24.5 「もっと読む」ボタンで Turbo Streams の append を使う
- 24.6 IntersectionObserver で「もっと読む」を自動化する
- 24.7 ボタンを残す理由（キーボード操作とスクリーンリーダー）
- 24.8 URL と `?page=`、戻る操作、スクロール位置
- 24.9 テスト: 追記の重複なし、最終ページの終端
- 24.10 アンチパターン: フッターに到達できない、戻ると位置喪失、監視解除漏れ
- ◎ <https://turbo.hotwired.dev/reference/attributes>
- ◎ <https://turbo.hotwired.dev/reference/streams>
- ◎ <https://stimulus.hotwired.dev/handbook/building-something-real>

## 第25章 バリデーションエラーとフォーム UX
**ねらい:** Hotwire 最大のハマりどころであるステータスコードとフォーム再描画を正面から扱う。第8章の 422 を実戦投入する。

- 25.1 完成イメージ: 失敗時はインラインエラー、成功時は一覧と flash を同時更新
- 25.2 この章の選択: サーバー検証を主役にし、Stimulus は補助に回す
- 25.3 失敗時に 422 を返す（コードでは `status: :unprocessable_entity` を使う）
- 25.4 Frame またはページ再描画でフォームを同じ場所に戻す
- 25.5 成功時に Turbo Streams で一覧と flash を更新する
- 25.6 Stimulus で送信中表示、二重送信防止、文字数カウンタを足す
- 25.7 a11y: エラーサマリ、フォーカス移動、`aria-invalid`、`aria-describedby`、`role="alert"`
- 25.8 URL は基本不変にする
- 25.9 テスト: 無効入力、有効入力、二重送信防止
- 25.10 アンチパターン: 失敗時に 422 ではなく 200 で render する、JS 検証だけにする、エラー時にフォーカスが迷子になる
- ◎ <https://turbo.hotwired.dev/handbook/drive>
- ◎ <https://turbo.hotwired.dev/reference/attributes>
- ○ <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA>

## 第26章 モーダル、タブ、ドロップダウン
**ねらい:** 同じ見た目でも、サーバー状態が要るかどうかで実装が分かれることを学ぶ。

- 26.1 完成イメージ: 新規作成モーダル、タブ切替、ドロップダウンメニュー
- 26.2 この章の選択: サーバー内容が要る UI と Stimulus 単独で足りる UI を仕分ける
- 26.3 ドロップダウンを Stimulus だけで作る
- 26.4 静的タブを Stimulus だけで作る
- 26.5 遅延タブを Turbo Frames で読み込む
- 26.6 モーダルを `turbo_frame_tag "modal"` と `<dialog>` で作る
- 26.7 成功時に Turbo Streams でモーダルを空にし、一覧を更新する
- 26.8 a11y: focus trap、Esc、フォーカス復帰、tablist / tab / tabpanel、キーボード操作
- 26.9 URL: モーダルをディープリンクにするかどうか
- 26.10 テスト: 開閉、Esc、フォーカス、送信成功後の更新
- 26.11 アンチパターン: モーダル乱用、`<div>` 自作でキーボード操作崩壊、Stimulus でサーバー内容を二重管理
- ◎ <https://stimulus.hotwired.dev/reference/controllers>
- ◎ <https://turbo.hotwired.dev/handbook/frames>
- ◎ <https://turbo.hotwired.dev/reference/streams>
- ○ <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog>

## 第27章 通知、トースト、フラッシュメッセージ
**ねらい:** 「Turbo Streams で差し込む + Stimulus で演出 + Action Cable で配信」を総まとめする。

- 27.1 完成イメージ: 操作後にトーストが出て自動で消える。他ユーザーの操作も通知できる
- 27.2 この章の選択: 差し込みは Streams、演出は Stimulus、他者発は Action Cable に分ける
- 27.3 通常の flash を整理する
- 27.4 Turbo Streams で flash 領域を更新する
- 27.5 Stimulus で自動消滅、閉じるボタン、transition を扱う
- 27.6 複数通知のスタック管理
- 27.7 Action Cable broadcast でリアルタイム通知に拡張する
- 27.8 a11y: `role="status"`、`aria-live="polite"`、重要情報をトーストだけにしない
- 27.9 テスト: 表示、時間経過で消滅、積み重ね
- 27.10 アンチパターン: aria-live なし、無限に積もる、見せてはいけない情報を broadcast する
- ◎ <https://turbo.hotwired.dev/reference/streams>
- ◎ <https://guides.rubyonrails.org/action_cable_overview.html>
- ○ <https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Live_Regions>

## 横断コラム: 第7部 a11y チェックリスト
**ねらい:** 各章で扱ったアクセシビリティ上の注意点を、第8部の保守・テストへ橋渡しする。

- フォーカスは操作後に自然な場所へ残るか
- 更新結果は `aria-live` で伝わるか
- エラーは `aria-invalid` / `aria-describedby` と結びついているか
- キーボードだけで操作できるか
- 自動で消える情報が重要情報を含んでいないか
- System Test で最低限の操作経路を確認しているか

---

<a id="outline-part8"></a>
# 第8部 Hotwire アプリを保守する

この部を貫く軸は「**Hotwire は、遅い Rails も危ない Rails も隠してくれない**」です。Hotwire は Rails の上の薄い層なので、保守は「Rails の保守＋Hotwire 固有の観察点」になります。第28〜31章は、動いた後のアプリを 見る（テスト）→ 切り分ける（デバッグ）→ 測る（性能）→ 守る（認可）の順で支えます。第3〜7部で各章に仕込んだ小テスト（8.6 / 12.6 / 16.6 / 20.6 や、第7部の 23.9 / 24.9 / 25.9 / 26.10 / 27.9 など）、broadcast の認可入口（18.5）、id 設計（17.5）が、ここで回収されます。

## 第28章 Hotwire のテスト
**ねらい:** テスト戦略を立てる。何を System Test で守り、何をモデル・リクエストなど下位のテストに委ねるかの配分を決め、各章で書いた小テストをその中に位置づける。第7部で章ごとに散らしたテストを、ここで「戦略」として束ねる。

- 28.1 なぜ System Test が重要か
- 28.2 各ハンズオンで小さくテストする方針
- 28.3 Turbo Drive のテスト
- 28.4 Frames のテスト
- 28.5 Streams のテスト
- 28.6 Stimulus の振る舞いを確認する
- 28.7 非同期更新を待つ（Capybara の自動待機、`sleep` を使わない）
- 28.8 壊れやすいテストを避ける（待機の明示、broadcast の同期化）
- ◎ <https://guides.rubyonrails.org/testing.html>

## 第29章 デバッグとイベント観察
**ねらい:** 観察ツールを体系化する。DevTools・Turbo / Stimulus のイベント・ネットワークという道具立てを揃え、「どこで差し替えが止まったか」を再現性をもって切り分けられるようにする。第7部の a11y 観点も、ここで観察手段として道具化する。

- 29.1 Network タブで見るべきもの
- 29.2 Turbo イベントをログに出す
- 29.3 Stimulus controller の接続を確認する
- 29.4 Frame / Stream の target を確認する
- 29.5 morphing の差分を疑う
- 29.6 フォーカス崩れ・読み上げ崩れを DevTools とイベントログで切り分ける（a11y の方針自体は第7部、ここは原因切り分けに徹する）
- 29.7 よくあるエラーの読み方
- ◎ <https://turbo.hotwired.dev/reference/events>
- ◎ <https://stimulus.hotwired.dev/reference/lifecycle-callbacks>

## 第30章 パフォーマンスと N+1
**ねらい:** Hotwire の体感速度を損なう Rails 側の問題を見つけ、改善する。

- 30.1 Hotwire は遅い Rails を隠してくれない
- 30.2 partial rendering のコスト
- 30.3 N+1 と preload
- 30.4 broadcast の回数
- 30.5 キャッシュの使いどころ
- 30.6 大きすぎる Turbo Streams
- 30.7 測定してから直す
- ◎ <https://guides.rubyonrails.org/caching_with_rails.html>

## 第31章 認証、認可、セキュリティ
**ねらい:** Hotwire の部分更新や broadcast でも、通常の Rails と同じく認可を崩さない設計を学ぶ。

- 31.1 controller の認可を省略しない
- 31.2 Frame / Stream でも権限を確認する
- 31.3 broadcast の配信範囲
- 31.4 署名付き stream 名への購読（`turbo_stream_from` は購読名の改ざんを防ぐ。これは認可ではなく、アクセス制御は controller / model 側で別途行う）
- 31.5 CSRF とフォーム
- 31.6 ユーザーごとの DOM id
- 31.7 第18章との責務分担
- ◎ <https://guides.rubyonrails.org/security.html>
- ◎ <https://guides.rubyonrails.org/action_cable_overview.html>

---

<a id="outline-part9"></a>
# 第9部 Hotwire Native

この部を貫く軸は「**同じ Relay を、ネイティブの殻で包む**」です。Hotwire Native は、既存の Web 画面をそのまま WebView で表示し、必要な部分だけネイティブに置き換える Web-first な構成です。第32〜35章は「考え方を掴む → URL ごとの見せ方を決める（Path Configuration）→ Web とネイティブをつなぐ（Bridge Components）→ ネイティブ画面を足す（Native Screens）」と進みます。第7部までで Relay の HTML が整っているほど、ネイティブ化の追加コストは小さくなります。第10部（第37・38章）への助走でもあります。

本編（第32〜35章）は **考え方と設計** に絞ります。Xcode / Android Studio を要する **実機ビルドの手順は付録H** に分離し、ネイティブ開発環境がない読者も本編を読み進められるようにします。

## 第32章 Hotwire Native の考え方
**ねらい:** Hotwire Native を、Web 画面を活かす Web-first なモバイルアプリ構成として理解する。

- 32.1 Hotwire Native とは
- 32.2 WebView と native shell
- 32.3 すべてをネイティブ化しない判断
- 32.4 Web 側に求められる設計（レスポンシブ、ナビゲーション、認証の共有 →第7部の UI 品質に依存）
- 32.5 iOS / Android の大まかな違い
- ◎ <https://native.hotwired.dev/>

## 第33章 Path Configuration
**ねらい:** URL ごとの表示方法や遷移方法を Path Configuration で制御する考え方を学ぶ。

- 33.1 Path Configuration の役割
- 33.2 URL pattern
- 33.3 presentation（modal / push などの提示方法）
- 33.4 rules の管理（サーバ配信で後から更新）
- 33.5 Web 側ルーティングとの関係（→第7部ch26 モーダルの URL 設計と呼応）
- ◎ <https://native.hotwired.dev/>

## 第34章 Bridge Components
**ねらい:** Web とネイティブの境界を Bridge Components でつなぐ。

- 34.1 Bridge Components とは
- 34.2 Web 側のマークアップ（`data-controller` で橋渡し、→第6部 Stimulus の上に乗る）
- 34.3 ネイティブ側の component
- 34.4 メッセージの送受信（Web ⇄ ネイティブ）
- 34.5 使いすぎを避ける判断（Web で足りるなら橋を架けない）
- ◎ <https://native.hotwired.dev/>

## 第35章 Native Screens
**ねらい:** ネイティブ画面が必要になる場面と、Web 画面との責務分担を理解する。

- 35.1 Native Screens とは
- 35.2 ログイン、決済、カメラなどの候補
- 35.3 WebView へ戻る導線
- 35.4 状態同期（認証・セッションの受け渡し、→第31章）
- 35.5 テストと配布の注意点（ストア審査、更新サイクル）
- ◎ <https://native.hotwired.dev/>

---

<a id="outline-part10"></a>
# 第10部 Hotwire を選ぶべきか

## 第36章 Hotwire のアンチパターン
**ねらい:** Hotwire を使うほど複雑になる場面を知り、別の設計へ切り替える判断軸を持つ。

- 36.1 すべてを Frame に入れる
- 36.2 controller が分岐だらけになる
- 36.3 Stimulus に状態管理を押し込む
- 36.4 broadcast が広すぎる
- 36.5 URL と画面状態が一致しない
- 36.6 a11y を後回しにする
- 36.7 通常の Rails に戻す判断
- ○ <https://turbo.hotwired.dev/handbook/building>

## 第37章 React / Vue / SPA との使い分け
**ねらい:** Hotwire と SPA フレームワークを対立ではなく選択肢として比較する。

- 37.1 比較する軸
- 37.2 Hotwire が強い場面
- 37.3 SPA が強い場面
- 37.4 混在させる場合
- 37.5 API 設計が必要になる場面
- 37.6 チームのスキルと保守コスト
- 37.7 採用判断チェックリスト
- ◎ <https://hotwired.dev/>

## 第38章 Hotwire の未来
**ねらい:** Hotwire の現在地と今後の方向性を、Turbo 8 以降の流れも含めて整理する。

- 38.1 Turbo 8 と morphing の意味
- 38.2 refresh broadcast の可能性
- 38.3 Hotwire Native の成熟
- 38.4 Rails 標準としての Hotwire
- 38.5 SPA との境界はどう変わるか
- 38.6 本書の後に学ぶこと
- ◎ <https://turbo.hotwired.dev/handbook/page_refreshes>
- ◎ <https://native.hotwired.dev/>

---

<a id="outline-appendix"></a>
# 付録

- 付録A 公式ドキュメントの歩き方
- 付録B Turbo 属性・イベント一覧
- 付録C Turbo Streams アクション一覧
- 付録D Stimulus リファレンス
- 付録E よくあるエラーと対処
- 付録F AI に Hotwire コードを依頼するときのプロンプト集
- 付録G 完成版サンプルアプリのコード解説
- 付録H Hotwire Native ハンズオン（実機ビルド手順 / Xcode・Android Studio 前提）
