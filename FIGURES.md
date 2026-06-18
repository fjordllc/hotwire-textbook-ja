# 図版計画

本書で使う図版の内容・配置・alt テキストを管理します。本書は「サーバーとブラウザの間で何が流れるか」「どの要素がどう差し替わるか」を扱うため、図版が理解を大きく助けます。最小限ではなく、つまずきやすい箇所に豊富に配置する方針です。

## 方針

- 図版は Hotwire の仕組みを理解するために使う（装飾目的は置かない）。
- Rails の controller / view と、Turbo / Stimulus / ブラウザの関係を視覚化する。
- 図版ファイルは `manuscript/figures/` に置く（`fig-<章>-<連番>.svg` などを想定）。
- 見た目のルールは `FIGURE_STYLEGUIDE.md` に従う。
- 各図版は、本文の該当節の直後に配置し、alt テキストを必ず付ける。

各図版は次の項目で記述する。

- <strong>配置</strong>: どの章・節の、どの説明の直後に置くか。
- <strong>種別</strong>: 概念図 / シーケンス図 / 構造図 / 状態遷移図 / 比較図 / フローチャート。
- <strong>ねらい</strong>: その図で何を理解させるか。
- <strong>描画内容</strong>: 要素・矢印・ラベル・レイアウトの詳細。
- <strong>alt</strong>: 代替テキスト。

---

# 第1部 Hotwire を理解する

### fig-1-1: Hotwire の全体像
- <strong>配置</strong>: 第1章 1.2（Turbo / Stimulus / Hotwire Native の役割）の直後。
- <strong>種別</strong>: 概念図。
- <strong>ねらい</strong>: Hotwire が複数の道具の集まりであり、すべてが「HTML over the wire」の上に立つことを一目で示す。
- <strong>描画内容</strong>: 中央に「HTML over the wire（サーバーが HTML を送り、ブラウザが反映する）」の帯。その上に 3 つの箱: 「Turbo（Drive / Frames / Streams）= HTML の送受信と画面更新」「Stimulus = HTML に振る舞いを足す」「Hotwire Native = Web をモバイルへ」。各箱から下の帯へ「同じ思想の現れ」という矢印。右端に対応章のラベル（第3〜5部 / 第6部 / 第9部）。
- <strong>alt</strong>: Hotwire は Turbo・Stimulus・Hotwire Native からなり、いずれも「HTML over the wire」という共通の考え方の上に立つことを示す図。

### fig-1-2: Relay を育てる全体像
- <strong>配置</strong>: 第1章 1.5（サンプルアプリの見取り図）の直後。
- <strong>種別</strong>: フロー（成長）図。
- <strong>ねらい</strong>: 1 つのアプリ（Relay）を素の CRUD から段階的に Hotwire 化していく、本書全体の道筋を示す。
- <strong>描画内容</strong>: 左に「素の Rails CRUD（第2部）」の箱。右へ矢印が伸び、各段で機能が増える: 「高速な遷移（第3部 Drive）」→「部分更新（第4部 Frames）」→「画面遷移なし更新・リアルタイム（第5部 Streams）」→「振る舞い（第6部 Stimulus）」→「実務 UI（第7部）」→「保守（第8部）」→「モバイル（第9部）」。最終段に「実務水準の Relay」。各段の下に主要画面のサムネイル（一覧・詳細・モーダル）。
- <strong>alt</strong>: 素の CRUD から各部で機能を足し、実務水準の Relay へ育てる本書全体の道筋を示す図。

### fig-2-1: 画面更新の歴史
- <strong>配置</strong>: 第2章 2.4（HTML を送ることの再評価）の直後。
- <strong>種別</strong>: タイムライン（比較図）。
- <strong>ねらい</strong>: 全ページ再読み込み → Ajax → JSON/SPA → HTML over the wire という流れと、各段の利点・代償を整理する。
- <strong>描画内容</strong>: 横軸に時間。4 つの段階を並べる。各段に「サーバーが返すもの（HTML 全体 / 部分 JSON / JSON / HTML 部分）」「画面を組み立てる場所（サーバー / ブラウザ）」「代償（白い再描画 / JS 増 / 複雑さ / —）」を小さな表で。最後の段「HTML over the wire」に丸印を付け、「Ajax の部分更新＋サーバーが HTML」を強調。
- <strong>alt</strong>: 全ページ再読み込みから Ajax、JSON/SPA を経て、HTML over the wire に至る画面更新の歴史を、各段の利点と代償とともに示すタイムライン。

### fig-2-2: JSON+SPA と HTML over the wire の通信比較
- <strong>配置</strong>: 第2章 2.4 の終盤、fig-2-1 の後。
- <strong>種別</strong>: 比較図（2 系統の通信）。
- <strong>ねらい</strong>: 「wire（通信路）を流れるもの」と「画面を組み立てる場所」の違いを対比する。
- <strong>描画内容</strong>: 上段（SPA）: サーバー → JSON → ブラウザ内 JavaScript が DOM を構築。状態はブラウザ側に大きな箱。下段（Hotwire）: サーバーが HTML を構築 → HTML → ブラウザが差し替えるだけ。状態はサーバー側。両者で「JavaScript の量」のバーを大小で対比。
- <strong>alt</strong>: SPA は JSON を送りブラウザで画面を組み立てるのに対し、Hotwire は HTML を送りブラウザは差し替えるだけ、という通信と責務の違いを対比する図。

### fig-3-1: Rails の仕組みと Hotwire の接続点
- <strong>配置</strong>: 第3章 3.5（Rails 設計の変化）の直後。
- <strong>種別</strong>: 構造図（対応関係）。
- <strong>ねらい</strong>: Rails の既存概念が、Hotwire のどの機能に自然につながるかを示す。
- <strong>描画内容</strong>: 左列に Rails の概念（MVC で HTML を返す / partial / RESTful controller / Action Cable）。右列に Hotwire（Turbo Drive・Frames / Turbo Streams / Turbo Streams 応答 / broadcast）。対応する項目を線で結ぶ。中央に「延長であって、別物ではない」の注記。
- <strong>alt</strong>: Rails の MVC・partial・REST・Action Cable が、それぞれ Turbo Drive/Frames・Streams・broadcast へ自然につながることを線で結んだ対応図。

---

# 第2部 ハンズオンの準備

### fig-4-1: Relay のモデル関連図
- <strong>配置</strong>: 第4章 4.4（モデル構成）の直後。
- <strong>種別</strong>: ER 図。
- <strong>ねらい</strong>: 6 モデルの関連を一目で示す。
- <strong>描画内容</strong>: エンティティ: User / Project / Task / Comment / Tag / Tagging。関連: Project 1—* Task、Task 1—* Comment、Task *—* Tag（Tagging 経由）、Task *—1 User（assignee, 任意）、Comment *—1 User。各エンティティに主要属性（Task は status enum を強調）。assignee の線は破線で「任意」を表す。
- <strong>alt</strong>: Relay の 6 モデル（User/Project/Task/Comment/Tag/Tagging）の関連を示す ER 図。Task が中心で、Project・Comment・Tag・User とつながる。

### fig-4-2: 主要画面と使う技術の対応
- <strong>配置</strong>: 第4章 4.5（主要画面）の直後。
- <strong>種別</strong>: 画面マップ（対応図）。
- <strong>ねらい</strong>: どの画面で、どの Hotwire 技術を使うかを俯瞰させる。
- <strong>描画内容</strong>: Relay の画面ワイヤーフレーム（プロジェクト一覧 / タスク一覧 / タスク詳細サイドバー / 作成モーダル / コメント欄 / トースト）。各画面に技術タグ（Drive / Frames / Streams / Stimulus / Cable）を色分けで貼る。1 画面に複数タグが付くことを示す。
- <strong>alt</strong>: Relay の主要画面それぞれに、使う Hotwire 技術（Drive/Frames/Streams/Stimulus/Cable）を色タグで対応づけた画面マップ。

### fig-5-1: 認証ジェネレータの生成物
- <strong>配置</strong>: 第5章 5.2（認証の追加）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: `bin/rails generate authentication` が何を作るかと、ドメインモデルとの区別を示す。
- <strong>描画内容</strong>: 「認証ジェネレータ」から生成物を放射状に: User / Session / Current / SessionsController / PasswordsController / 認証 concern / PasswordsMailer / views / routes / bcrypt。User と Session を「ドメインに近い」枠、ほかを「認証インフラ」枠で囲み分ける。User に「name は後から追加」の吹き出し。
- <strong>alt</strong>: Rails 認証ジェネレータが User・Session・Current・各コントローラ・メイラー等を生成することと、ドメインモデルとの区別を示す図。

### fig-6-1: importmap の読み込み経路
- <strong>配置</strong>: 第6章 6.3（importmap）の直後。
- <strong>種別</strong>: 構造図（依存の流れ）。
- <strong>ねらい</strong>: `application.js` から Turbo / Stimulus がどう読み込まれるかを示す。
- <strong>描画内容</strong>: `app/javascript/application.js`（`import "@hotwired/turbo-rails"` / `import "controllers"`）→ `config/importmap.rb` の pin が名前を実体に解決 → turbo.min.js / stimulus.min.js / controllers/。controllers/index.js が `eagerLoadControllersFrom` で配下を自動登録、の枝も描く。ビルド工程がないことを「ビルド不要」の注記で強調。
- <strong>alt</strong>: application.js の import が importmap.rb の pin を介して Turbo・Stimulus・controllers に解決される、ビルド不要の読み込み経路図。

---

# 第3部 Turbo Drive

### fig-7-1: Turbo Drive のページ置換
- <strong>配置</strong>: 第7章 7.2（visit と body 差し替え）の直後（既存プレースホルダ位置）。
- <strong>種別</strong>: 比較図。
- <strong>ねらい</strong>: 通常遷移（全体作り直し）と visit（body だけ差し替え）の違いを示す。
- <strong>描画内容</strong>: 左（通常遷移）: ページ全体が破棄され、head も body も再構築、白い画面。右（visit）: head はマージ（CSS/JS は保持）、body だけ新しい HTML に差し替え。両者で「再読み込みされる範囲」を網掛けの大小で対比。
- <strong>alt</strong>: 通常遷移はページ全体を作り直すが、Turbo Drive の visit は head をマージして body だけ差し替えることを対比した図。

### fig-7-2: visit のシーケンス
- <strong>配置</strong>: 第7章 7.2 の終盤。
- <strong>種別</strong>: シーケンス図。
- <strong>ねらい</strong>: リンククリックから画面差し替えまでの流れを時系列で示す。
- <strong>描画内容</strong>: アクター: ユーザー / ブラウザ(Turbo) / サーバー。クリック → Turbo が fetch → サーバーが HTML を返す → Turbo が body 差し替え＋head マージ → 表示。サーバーは「通常どおり HTML を返すだけ」を注記。
- <strong>alt</strong>: リンククリックを Turbo が横取りして fetch し、返ってきた HTML で body を差し替えるまでのシーケンス図。

### fig-8-1: フォーム送信の契約（303 / 422）
- <strong>配置</strong>: 第8章 8.5（status code は契約）の直後。
- <strong>種別</strong>: フローチャート。
- <strong>ねらい</strong>: 成功＝redirect（303）、失敗＝422 render、200 は不可、という分岐を一望させる。
- <strong>描画内容</strong>: 「フォーム送信（POST/PATCH/DELETE）」から分岐。成功 → 「redirect（update/destroy は 303 See Other）」→ Turbo が follow して visit。失敗 → 「422 render」→ Turbo が body 差し替えでエラー表示。下に×印で「200 で render → 差し替わらず送信元 URL に留まる」を警告枠で。
- <strong>alt</strong>: フォーム送信の成功は redirect（303）、失敗は 422 render、200 は差し替わらない、という Turbo との契約を示すフローチャート。

### fig-9-1: snapshot cache とプレビュー
- <strong>配置</strong>: 第9章 9.2（preview 表示）の直後。
- <strong>種別</strong>: シーケンス／状態図。
- <strong>ねらい</strong>: 離脱時のスナップショット保存と、戻る/進む時のプレビュー→最新差し替えの流れを示す。
- <strong>描画内容</strong>: タイムライン: ページA表示 → 離脱直前に A のスナップショット保存（turbo:before-cache）→ ページB へ → 戻る操作 → A のキャッシュを即時プレビュー表示（html[data-turbo-preview]）→ 裏で最新取得 → 本物に差し替え。プレビュー中に「古い内容が一瞬出る」注意の吹き出し。
- <strong>alt</strong>: ページ離脱時にスナップショットを保存し、戻る操作でキャッシュをプレビュー表示してから最新に差し替える流れを示す図。

### fig-9-2: replace と morph の違い
- <strong>配置</strong>: 第9章 9.6（page refresh と morph）の直後。
- <strong>種別</strong>: 比較図。
- <strong>ねらい</strong>: 全置換（replace）と差分適用（morph）の違い、状態保持の有無を示す。
- <strong>描画内容</strong>: 同じリスト（1 件だけ status が変化）に対し、左（replace）: リスト全体が作り直され、フォーカス/スクロールが失われる（×印）。右（morph）: 変わった 1 件だけ書き換わり、フォーカス/スクロールは保持（○印）。data-turbo-permanent の要素は両者で「触らない」を示す。
- <strong>alt</strong>: 1 件だけ変化したリストで、replace は全体を作り直し状態を失うが、morph は変わった部分だけを書き換えて状態を保つ違いを示す図。

### fig-10-1: visit ライフサイクルのイベント
- <strong>配置</strong>: 第10章 10.1（主要イベント）の直後。
- <strong>種別</strong>: タイムライン。
- <strong>ねらい</strong>: visit 中に発火するイベントの順序と、割り込みできる箇所を示す。
- <strong>描画内容</strong>: 横一列に turbo:click → before-visit →（preventDefault で中断可の印）→ visit → before-render → render → load。フォーム系（submit-start / submit-end）を別レーンに。morph 系（before-morph-element / morph）も別レーン。各イベントに「ここで何ができるか」（確認・ローディング・中断・ログ）を小注記。
- <strong>alt</strong>: Turbo の visit 中に発火する主要イベントの順序と、中断や割り込みが可能な箇所を示すタイムライン。

---

# 第4部 Turbo Frames

### fig-11-1: Turbo Frame の id 一致
- <strong>配置</strong>: 第11章 11.2（id の一致ルール）の直後（既存プレースホルダ位置）。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: frame 内リンクが、レスポンスから同じ id の frame を抽出して差し替えることを示す。
- <strong>描画内容</strong>: 左に現在のページ（`<turbo-frame id="task_detail">` の中にリンク）。リンククリック → サーバーがページを返す（右）→ そのページの中の `id="task_detail"` の frame だけを点線で囲んで抽出 → 左の frame に差し替え。「id が一致しないと Content missing」の警告を下に。
- <strong>alt</strong>: frame 内のリンクが、レスポンスの同じ id を持つ turbo-frame だけを抽出して差し替える仕組みと、id 不一致時のエラーを示す図。

### fig-11-2: data-turbo-frame と _top
- <strong>配置</strong>: 第11章 11.5（別 frame を target）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: 既定（自分の frame）／別 frame 指定／_top（ページ全体）の差し替え先の違いを示す。
- <strong>描画内容</strong>: 1 つのページに frameA（中にリンク3本）と frameB。リンク1（既定）→ frameA を差し替え。リンク2（data-turbo-frame="frameB"）→ frameB を差し替え。リンク3（data-turbo-frame="_top"）→ ページ全体を visit。矢印で差し替え先を色分け。
- <strong>alt</strong>: frame 内リンクが既定で自分の frame を、data-turbo-frame で別 frame を、_top でページ全体を差し替えることを示す図。

### fig-12-1: インライン編集のフロー
- <strong>配置</strong>: 第12章 12.3（インライン編集）の直後。
- <strong>種別</strong>: 状態遷移図。
- <strong>ねらい</strong>: 行（frame）が「表示 ⇄ 編集」を、同じ id の frame の差し替えで行き来することを示す。
- <strong>描画内容</strong>: 状態「表示（_task）」と「編集（_form）」を 2 つの箱で。表示→編集: 「編集」リンク（edit の frame を抽出）。編集→表示（成功）: 保存 → 303 → show の frame。編集→表示（キャンセル）: task_path の frame。編集→編集（失敗）: 422 で同 frame にエラー。すべて `id="task_1"` の上で起きることを枠で囲んで強調。
- <strong>alt</strong>: タスク行の frame が、同じ id の上で表示と編集フォームを差し替え合い、保存・キャンセル・失敗で行き来するインライン編集の状態遷移図。

### fig-13-1: lazy loading と skeleton
- <strong>配置</strong>: 第13章 13.1〜13.2 の直後。
- <strong>種別</strong>: シーケンス図。
- <strong>ねらい</strong>: src + loading=lazy で、可視になってから取得し、skeleton が本体に差し替わる流れを示す。
- <strong>描画内容</strong>: ページ表示 → frame は skeleton（プレースホルダ）→ スクロールで frame が可視に入る → src を fetch → 返った frame で差し替え → 本体表示。「src だけなら即時、loading=lazy で可視まで遅延」を 2 本の矢印で対比。
- <strong>alt</strong>: src と loading=lazy を持つ frame が、画面に見えてから中身を取得し、skeleton を本体に差し替える流れを示す図。

### fig-13-2: frame の入れ子（サイドバー詳細）
- <strong>配置</strong>: 第13章 13.4（サイドバー詳細）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: detail frame の中に task_1 frame が入る入れ子と、その中でインライン編集も動くことを示す。
- <strong>描画内容</strong>: 画面を左右に。左=タスク一覧（各リンクは data-turbo-frame="detail"）。右=`<turbo-frame id="detail">`。その中に `<turbo-frame id="task_1">`（_task）が入っている入れ子を枠の二重線で。リンククリック → detail を差し替え、中の task_1 はさらに独立して編集できる、を注記。
- <strong>alt</strong>: 左の一覧から右の detail frame を差し替え、その detail の中に task_1 frame が入れ子になり、インライン編集も両立することを示す図。

### fig-14-1: frame / Streams / 通常遷移 の判断
- <strong>配置</strong>: 第14章 14.4〜14.5（切り替えの判断）の直後。
- <strong>種別</strong>: フローチャート。
- <strong>ねらい</strong>: 1 か所更新／複数同時更新／独立性が不要、で道具を選ぶ判断を示す。
- <strong>描画内容</strong>: 起点「画面を更新したい」。分岐1「独立した部分更新が要る?」No → 通常遷移（Turbo Drive）。Yes → 分岐2「更新は 1 か所?」Yes → Turbo Frames。No（複数同時）→ Turbo Streams。各葉に「できるか でなく 読みやすく保てるか」の基準を添える。
- <strong>alt</strong>: 部分更新の要否・更新箇所が1か所か複数かで、通常遷移・Turbo Frames・Turbo Streams を選ぶ判断フローチャート。

---

# 第5部 Turbo Streams

### fig-15-1: Turbo Streams のレスポンスと DOM 更新
- <strong>配置</strong>: 第15章 15.1（Turbo Streams とは）の直後（既存プレースホルダ位置）。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: `<turbo-stream action target><template>` の構造と、それが DOM のどこをどう操作するかを示す。
- <strong>描画内容</strong>: 左にレスポンス（`<turbo-stream action="append" target="tasks"><template>…</template></turbo-stream>`）。矢印で右の DOM（`<div id="tasks">`）へ。action（append）に従い template の中身が末尾に追加される様子。「turbo-stream 自体は表示されず命令として消える」を注記。
- <strong>alt</strong>: turbo-stream 要素の action・target・template の構造と、それが対象 id の DOM をどう操作するかを示す図。

### fig-15-2: 8 つのアクションの図解
- <strong>配置</strong>: 第15章 15.2（8 つの action）の直後。
- <strong>種別</strong>: 比較図（一覧）。
- <strong>ねらい</strong>: 8 アクションそれぞれが target に対して何をするかを、ビフォー/アフターで示す。
- <strong>描画内容</strong>: 3 列×3 段のカード。各カードに action 名と、target（既存の箱）に対する効果を小さなビフォー/アフターで: append（末尾追加）/ prepend（先頭追加）/ replace（要素ごと置換）/ update（中身だけ置換）/ remove（削除）/ before（直前挿入）/ after（直後挿入）/ refresh（ページ再描画アイコン）。replace と update の違いを枠線の有無で強調。
- <strong>alt</strong>: append・prepend・replace・update・remove・before・after・refresh の 8 アクションが対象要素に与える効果を、ビフォー/アフターで並べた図。

### fig-16-1: create の複数命令同時更新
- <strong>配置</strong>: 第16章 16.4（flash を更新）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: 1 レスポンスに複数の命令を入れ、離れた 3 か所を同時更新することを示す。
- <strong>描画内容</strong>: 1 つのレスポンス（3 つの turbo-stream を縦に: prepend tasks / update new_task_form / update flash）から、画面の 3 か所（一覧先頭 / フォーム領域 / フラッシュ領域）へそれぞれ矢印。「frame では 1 か所だけ → Streams なら複数同時」の対比注記。
- <strong>alt</strong>: 1 つのレスポンスに含めた 3 つの turbo-stream が、一覧・フォーム・フラッシュの 3 か所を同時に更新することを示す図。

### fig-17-1: dom_id が表示側と命令側を揃える
- <strong>配置</strong>: 第17章 17.5（id 設計と dom_id）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: `dom_id(task)` が、表示側の frame id と stream の target を自動で一致させることを示す。
- <strong>描画内容</strong>: 中央に `dom_id(@task) = "task_1"`。左へ「表示側 `turbo_frame_tag task` → id="task_1"」、右へ「命令側 `turbo_stream.replace @task` → target="task_1"」。両者が同じ "task_1" に収束する図。下に「手書き id はずれる」の×注記。
- <strong>alt</strong>: dom_id(task) が表示側の frame id と stream の target をどちらも "task_1" に揃え、ずれを防ぐことを示す図。

### fig-18-1: Action Cable broadcast
- <strong>配置</strong>: 第18章 18.1〜18.2（購読と配信）の直後。
- <strong>種別</strong>: 構造図（配信）。
- <strong>ねらい</strong>: 1 人の操作が、購読している全員へ Turbo Streams で配信される仕組みを示す。
- <strong>描画内容</strong>: サーバー中央。各クライアント（複数のブラウザ）が `turbo_stream_from @project` で同じ project ストリームを購読（点線で接続）。ユーザーAがタスク作成 → モデルの `broadcasts_to` → サーバーが project ストリームへ broadcast → 購読中の全クライアントに同じ stream が届き、各画面の一覧に追加。「配信先（streamable）= 届く範囲」を枠で強調。
- <strong>alt</strong>: 1 人のタスク作成が broadcasts_to で project ストリームに配信され、turbo_stream_from で購読する全クライアントの画面に反映される仕組みを示す図。

---

# 第6部 Stimulus

### fig-19-1: Stimulus controller と data 属性
- <strong>配置</strong>: 第19章 19.3〜19.5 の直後（既存プレースホルダ位置）。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: `data-controller` が HTML 側で controller を結びつけ、Turbo の差し替えのたびに connect/disconnect が呼ばれることを示す。
- <strong>描画内容</strong>: 左に HTML（`<div data-controller="autofocus">`）、右に JS（autofocus_controller.js）。名前で対応する線。下に Turbo のタイムライン: ページ差し替え時に「disconnect → 新要素に connect」が呼ばれる矢印。`DOMContentLoaded`（初回のみ ×）との対比を添える。
- <strong>alt</strong>: data-controller が HTML と controller を名前で結びつけ、Turbo の差し替えのたびに connect/disconnect が呼ばれることを、DOMContentLoaded との対比とともに示す図。

### fig-20-1: controller / action / target
- <strong>配置</strong>: 第20章 20.3（target の参照）の直後。
- <strong>種別</strong>: 構造図（三者関係）。
- <strong>ねらい</strong>: action（イベント→メソッド）と target（要素参照）が HTML と controller をどうつなぐかを示す。
- <strong>描画内容</strong>: HTML 側に `data-controller="counter"`、`data-action="input->counter#count"`、`data-counter-target="field"/"output"`。controller 側に `count()` と `this.fieldTarget`/`this.outputTarget`。input イベント → count → outputTarget 更新、の流れを矢印で。命名の対応（counter ↔ ファイル名、field ↔ static targets）を色で結ぶ。
- <strong>alt</strong>: data-action がイベントを controller のメソッドに、data-target が要素を this.xTarget に結びつけ、文字数カウンタが動く流れを示す図。

### fig-21-1: 状態を HTML に置く
- <strong>配置</strong>: 第21章 21.5（HTML 側に置く利点）の直後。
- <strong>種別</strong>: 概念図。
- <strong>ねらい</strong>: 状態を data 属性に置くと、Turbo のスナップショットに乗り、差し替え後も復元できることを示す。
- <strong>描画内容</strong>: 上段（HTML に状態）: `data-...-value` やクラスに状態 → スナップショットに含まれる → 復元時に connect が HTML から再構成（○）。下段（JS だけに状態）: controller のインスタンス変数 → 差し替えで消える（×）。
- <strong>alt</strong>: 状態を HTML の data 属性に置けばスナップショットに乗り復元できるが、JS のインスタンス変数だけだと差し替えで失われることを対比した図。

### fig-22-1: 外部ライブラリのライフサイクル
- <strong>配置</strong>: 第22章 22.5（Turbo cache との相互作用）の直後。
- <strong>種別</strong>: タイムライン。
- <strong>ねらい</strong>: connect で初期化・disconnect で破棄し、before-cache で後始末する対応関係を示す。
- <strong>描画内容</strong>: 横軸に時間。connect（ライブラリ初期化）… 操作 … turbo:before-cache（teardown で DOM を初期状態へ）… スナップショット保存（きれい）… disconnect（破棄）。「初期化したら破棄」を connect↔disconnect の括弧で、「キャッシュ前に片付け」を before-cache の注記で。二重初期化の×例も小さく。
- <strong>alt</strong>: 外部ライブラリを connect で初期化し disconnect で破棄、before-cache で DOM を片付けてからスナップショットを保存する、ライフサイクルの対応を示すタイムライン。

---

# 第7部 実務で使う Hotwire UI パターン

### fig-23-1: 検索の構成
- <strong>配置</strong>: 第23章 23.5〜23.6 の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: GET 検索フォーム → frame 差し替え＋advance で URL 反映、入力は Stimulus で debounce、という全体を示す。
- <strong>描画内容</strong>: 検索ボックス（data-controller="search"、input→debounce→requestSubmit）→ GET /tasks?q=… → `id="task_list"` の frame を差し替え。frame に data-turbo-action="advance" → アドレスバーが `?q=…` に更新。フォーカスは検索ボックスに留まる、を注記。
- <strong>alt</strong>: 検索入力を Stimulus が debounce して GET 送信し、task_list frame を差し替えつつ advance で URL に条件を反映する検索の構成図。

### fig-24-1: ページネーション3段階の比較
- <strong>配置</strong>: 第24章 24.1〜24.2 の直後。
- <strong>種別</strong>: 比較図。
- <strong>ねらい</strong>: ページ送り（置換）/ もっと読む（追記）/ 無限スクロール（検知＋追記）の違いと使う道具を示す。
- <strong>描画内容</strong>: 3 列。ページ送り: 一覧が次ページに置換、URL に ?page=、道具=Frames。もっと読む: ボタンで末尾に追記、道具=Streams append。無限スクロール: 末尾が見えたら自動でボタンを押す、道具=Stimulus（IntersectionObserver）+ Streams。各列に URL 再現性・a11y の○×を添える。
- <strong>alt</strong>: ページ送り・もっと読む・無限スクロールの 3 方式を、使う道具（Frames/Streams/Stimulus）と URL 再現性・a11y の観点で比較した図。

### fig-25-1: フォーム UX と a11y
- <strong>配置</strong>: 第25章 25.7（a11y）の直後。
- <strong>種別</strong>: 注釈付きワイヤーフレーム。
- <strong>ねらい</strong>: 422 でその場再描画されたフォームに、a11y 要素がどう付くかを示す。
- <strong>描画内容</strong>: フォームのワイヤーフレーム。先頭にエラーサマリ（role="alert"、tabindex=-1、autofocus controller でフォーカス）。エラーのある入力に aria-invalid と aria-describedby、その下にエラーメッセージ（id 紐づけ）。送信ボタンに data-turbo-submits-with（送信中無効）。各要素から吹き出しで役割を説明。
- <strong>alt</strong>: 422 で再描画されたフォームに、エラーサマリへのフォーカス、aria-invalid/aria-describedby、送信中ボタン無効化が付く様子を注釈したワイヤーフレーム。

### fig-26-1: サーバー状態の要否で道具を選ぶ
- <strong>配置</strong>: 第26章 26.2（この章の選択）の直後。
- <strong>種別</strong>: フローチャート。
- <strong>ねらい</strong>: ドロップダウン/静的タブ＝Stimulus、遅延タブ/モーダル＝Frames/Streams、の仕分けを示す。
- <strong>描画内容</strong>: 起点「この UI に、サーバーの内容が要る?」No → Stimulus 単独（ドロップダウン・静的タブ）。Yes → Frames で取得（遅延タブ・モーダル）→ 送信で複数更新なら Streams。各葉に具体例。
- <strong>alt</strong>: UI にサーバー内容が要るかどうかで、Stimulus 単独か Turbo Frames/Streams かを仕分ける判断フローチャート。

### fig-26-2: モーダルの構成
- <strong>配置</strong>: 第26章 26.6〜26.7 の直後。
- <strong>種別</strong>: シーケンス／構造図。
- <strong>ねらい</strong>: turbo_frame "modal" + dialog + Stimulus open + 成功時 Streams close の流れを示す。
- <strong>描画内容</strong>: 「新規作成」リンク（data-turbo-frame="modal"）→ new_task_path → `id="modal"` の frame に `<dialog data-controller="modal">` → connect で showModal()。送信成功 → create.turbo_stream で「prepend tasks ＋ update modal（空）＝閉じる ＋ flash」。Esc → dialog close → cleanup で remove。
- <strong>alt</strong>: 新規作成リンクが modal frame に dialog を読み込んで開き、送信成功時に Streams でモーダルを空にして閉じつつ一覧を更新する、モーダルの構成図。

### fig-27-1: 通知の合わせ技
- <strong>配置</strong>: 第27章 27.2（この章の選択）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: 差し込み（Streams）・演出（Stimulus）・他者発（Cable）の役割分担を示す。
- <strong>描画内容</strong>: トースト 1 個を中心に、3 方向から役割を矢印で: 左「Turbo Streams: #toasts に append（差し込み）」、右「Stimulus: 自動消滅・閉じる・transition（演出）」、上「Action Cable: 他ユーザーの操作を broadcast（配信）」。#toasts に role="status"/aria-live の注記。
- <strong>alt</strong>: トーストが、Streams による差し込み・Stimulus による演出・Action Cable による他者発配信の 3 役で成り立つことを示す図。

---

# 第8部 Hotwire アプリを保守する

### fig-28-1: テストの配分（ピラミッド）
- <strong>配置</strong>: 第28章 28.2（テストの配分）の直後。
- <strong>種別</strong>: ピラミッド図。
- <strong>ねらい</strong>: モデル/リクエスト/System の配分と、Hotwire の結合を System で守ることを示す。
- <strong>描画内容</strong>: 三角形。下から「モデルテスト（多い・速い: バリデーション/enum/スコープ）」「リクエストテスト（中: status/turbo_stream/絞り込み）」「System テスト（少ない・遅い: Hotwire の結合）」。右に各章の対応（8.6/12.6/16.6/20.6/23.9）を添える。
- <strong>alt</strong>: モデル・リクエスト・System テストの配分をピラミッドで示し、Hotwire の結合を System テストで守ることを表した図。

### fig-29-1: デバッグの切り分け順
- <strong>配置</strong>: 第29章 冒頭（観察の順序）の直後。
- <strong>種別</strong>: フローチャート。
- <strong>ねらい</strong>: Network → Turbo events → Stimulus → target → morph の順で原因を絞る道筋を示す。
- <strong>描画内容</strong>: 縦に 5 ステップ。各ステップに「見るもの」と「ここで分かること」: Network（メソッド/Accept/ステータス/中身）→ Turbo events（動いているか）→ Stimulus（接続ログ）→ target（id 一致）→ morph（差分）。各ステップから「該当ならここで判明」の分岐。
- <strong>alt</strong>: 不具合を Network・Turbo イベント・Stimulus 接続・target id・morph の順で切り分けるデバッグの手順フローチャート。

### fig-30-1: N+1 と includes
- <strong>配置</strong>: 第30章 30.3（N+1 と preload）の直後。
- <strong>種別</strong>: 比較図。
- <strong>ねらい</strong>: 一覧描画で N+1 が起きる様子と、includes で解消する様子をクエリ本数で対比する。
- <strong>描画内容</strong>: 左（N+1）: タスク一覧20件 → 1 + 20（assignee）+ 20（tags）… の多数のクエリ。右（includes）: `includes(:assignee, :tags)` → まとめて数本。クエリ本数のバーを大小で対比。「broadcast の partial でも同じ」の注記。
- <strong>alt</strong>: 一覧描画で関連ごとにクエリが増える N+1 と、includes でまとめて読み込み本数が減る様子をクエリ本数で対比した図。

### fig-31-1: 配信範囲と認可の切り分け
- <strong>配置</strong>: 第31章 31.4（署名付き stream 名）の直後。
- <strong>種別</strong>: 概念図。
- <strong>ねらい</strong>: 署名＝改ざん防止であって認可ではない、認可は controller/model で、という層を分けて示す。
- <strong>描画内容</strong>: 3 層の盾。外側「署名付き stream 名（購読名の改ざん防止）」、中「配信範囲の設計（streamable で届く範囲を絞る）」、内「controller/model の認可（誰が見て・してよいか）」。「署名は認可ではない」を太字注記。広すぎる配信先の×例を脇に。
- <strong>alt</strong>: 署名付き stream 名は改ざん防止、配信範囲は streamable で絞る、認可は controller/model、という別レイヤーであることを示す図。

---

# 第9部 Hotwire Native

### fig-32-1: WebView と native shell
- <strong>配置</strong>: 第32章 32.2（WebView と native shell）の直後（既存プレースホルダ位置）。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: ネイティブの殻の中で Web 画面（Relay の HTML）が動く構成を示す。
- <strong>描画内容</strong>: スマホの外枠。上部にネイティブのナビゲーションバー（native shell）、本体に WebView（Relay の Web 画面）。「ナビゲーション・タブ・遷移＝ネイティブ」「中身の画面＝Web（サーバーの HTML）」をラベル。Web 更新はストア不要、ネイティブ部分はストア配信、の注記を添える。
- <strong>alt</strong>: ネイティブのナビゲーションシェルの中で WebView が Relay の Web 画面を表示する、Hotwire Native の構成図。

### fig-33-1: Path Configuration
- <strong>配置</strong>: 第33章 33.3（presentation）の直後。
- <strong>種別</strong>: 対応図。
- <strong>ねらい</strong>: URL パターンが、ネイティブの見せ方（モーダル/プッシュ）に対応づくことを示す。
- <strong>描画内容</strong>: 左に URL パターン（/tasks/new、/tasks/:id/edit、その他）。右にネイティブの提示（modal / push）。ルール（JSON の rules）が両者を結ぶ。サーバー配信なら更新可、ネイティブ機能の変更はストア、の注記。
- <strong>alt</strong>: URL パターンとネイティブの提示方法（モーダル/プッシュ）を Path Configuration の rules が対応づけることを示す図。

### fig-34-1: Bridge Components
- <strong>配置</strong>: 第34章 34.4（メッセージの送受信）の直後。
- <strong>種別</strong>: 構造図（往復）。
- <strong>ねらい</strong>: Web の Stimulus と ネイティブ component が、名前で対応しメッセージを往復することを示す。
- <strong>描画内容</strong>: 左に Web（`data-controller="submit-button"` のブリッジ Stimulus）、右にネイティブ component。Web→ネイティブ「ボタンを出して」、ネイティブ→Web「押された」の双方向矢印。下に「ブラウザでは component がないので何も起きない＝フォールバックを残す」のプログレッシブ・エンハンスメント注記。
- <strong>alt</strong>: Web のブリッジ Stimulus controller とネイティブ component が名前で対応し、指示と出来事のメッセージを往復する Bridge Components の図。

### fig-35-1: Web 画面とネイティブ画面の混在と認証同期
- <strong>配置</strong>: 第35章 35.4（状態同期）の直後。
- <strong>種別</strong>: 構造図。
- <strong>ねらい</strong>: ネイティブ画面と Web 画面が同じアプリ内で混在し、認証セッションを受け渡すことを示す。
- <strong>描画内容</strong>: アプリ内のナビゲーションスタックに、ネイティブのログイン画面 → Web のタスク一覧（WebView）が並ぶ。ネイティブで得た認証（cookie/トークン）を WebView のセッションへ受け渡す矢印。「受け渡しは安全に（第31章）／具体は付録H」の注記。
- <strong>alt</strong>: ネイティブのログイン画面と Web のタスク一覧が同じアプリ内に混在し、認証セッションを WebView へ受け渡すことを示す図。

---

# 第10部 Hotwire を選ぶべきか

### fig-37-1: Hotwire と SPA の比較軸
- <strong>配置</strong>: 第37章 37.1（比較する軸）の直後。
- <strong>種別</strong>: スペクトラム（比較図）。
- <strong>ねらい</strong>: 描画・状態・通信・JS 量の 4 軸で、Hotwire と SPA の位置を対比する。
- <strong>描画内容</strong>: 4 本の横軸（描画: サーバー↔クライアント / 状態: サーバー↔クライアント / 通信: HTML↔JSON / JavaScript 量: 少↔多）。各軸上に Hotwire と SPA の点を置く。中央付近に「SSR メタフレームワークで境界はぼやける」の注記。
- <strong>alt</strong>: 描画・状態・通信・JavaScript 量の 4 軸上で、Hotwire と SPA の位置を対比し、境界がぼやけることも示したスペクトラム図。

### fig-37-2: 採用判断フローチャート
- <strong>配置</strong>: 第37章 37.7（採用判断チェックリスト）の直後。
- <strong>種別</strong>: フローチャート。
- <strong>ねらい</strong>: 主な問いに答えていくと、Hotwire 向き／SPA・混在向きが見えることを示す。
- <strong>描画内容</strong>: 「データの CRUD が中心?」「クライアント状態は小さい?」「オフライン不要?」「チームは Rails 寄り?」「Web だけなら API 不要?」の問いを縦に。Yes が多い → Hotwire、No が多い → SPA / 混在。各分岐に第37章の該当節。
- <strong>alt</strong>: CRUD 中心か・クライアント状態・オフライン・チーム・API 要否の問いから、Hotwire 向きか SPA/混在向きかを導く採用判断フローチャート。

---

## 制作メモ

- 既存のプレースホルダ（本文中の `<!-- fig-… -->` コメント）は、第4章・第7章に入っている。他章は本図版計画に沿って、該当節の直後にプレースホルダと図を追加する。
- 図版は、本文の理解を助ける順（仕組み → 流れ → 判断）に優先制作するとよい。とくに fig-7-1（visit 置換）、fig-8-1（303/422 契約）、fig-11-1（id 一致）、fig-15-1/15-2（stream）、fig-18-1（broadcast）、fig-19-1（Stimulus ライフサイクル）、fig-32-1（WebView+shell）は、各部の核となる。
- すべての図に alt を付け、`FIGURE_STYLEGUIDE.md` の配色・線・フォント規則に従う。
