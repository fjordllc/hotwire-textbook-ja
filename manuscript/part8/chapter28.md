# 第28章 Hotwire のテスト

## この章のねらい

第7部までで、Relay は実務水準の管理画面になりました。第8部では、動いた後のアプリを保守します。最初はテストです。

この章のねらいは、テストの<strong>戦略</strong>を立てることです。何を System Test で守り、何をモデルやリクエストのテストに委ねるか。その配分を決め、第3〜7部で各章に書いてきた小さなテストを、その中に位置づけます。

> この部を貫く軸は「Hotwire は、遅い Rails も危ない Rails も隠してくれない」です。Hotwire は Rails の上の薄い層なので、テストも「Rails のテスト＋Hotwire 固有の観察点」になります。

## 28.1 なぜ System Test が重要か

Hotwire の動きは、部分更新の積み重ねです。フォームを送ると一覧が prepend され、件数が変わり、フラッシュが出る。これらは、ブラウザの上で JavaScript（Turbo・Stimulus）が動いて初めて成立します。

サーバー側のテストだけでは、ここを確かめきれません。controller が正しい Turbo Streams を返しても、それがブラウザで正しく適用されるか、Stimulus の controller が結びついて動くか、までは見られないからです。

だから、ブラウザを動かす System Test が要ります。System Test は、実際のブラウザ（ヘッドレスの Chrome など）で画面を操作し、Hotwire の結合部を確かめます。

## 28.2 テストの配分

とはいえ、何でも System Test で確かめるのは重すぎます。System Test は遅く、壊れやすいからです。テストは、層で分けて配分します。

- <strong>モデルのテスト</strong> … バリデーション、enum、検索のスコープなど、サーバー側のロジック。速くて確実なので、ここで手厚く。
- <strong>リクエストのテスト</strong> … controller が返すステータスや形式。422 が返るか（第8章）、`turbo_stream` 形式で応答するか、検索パラメータで正しく絞り込むか（第23章）。条件の組み合わせは、ここで網羅。
- <strong>System Test</strong> … 上の積み重ねが、ブラウザで結合して動くか。インライン編集の差し替え、Streams の追加、Stimulus の振る舞いなど、JavaScript が絡む経路に絞る。

第7部までで各章に書いてきた小さなテストは、この配分の中に収まります。「条件は下の層で、結合は System Test で」と分けると、軽く確実なテストになります。

<!-- fig-28-1: テストの配分（ピラミッド）。下からモデル（多い・速い）・リクエスト（中）・System（少ない・遅い）を積み、Hotwire の結合を System で守ることを示すピラミッド図 -->


## 28.3 Turbo Drive のテスト

Turbo Drive の確認は、第8章で書いたフォーム送信のテストが代表です。

- 成功すると詳細へ遷移し、成功メッセージが出る
- 失敗すると、ページ遷移せず、同じ画面にエラーが出る（422）

「ページ遷移したか／しなかったか」が、Turbo Drive のテストの肝です。失敗時にページ遷移していないことを確かめると、422 の契約が効いていると分かります。

## 28.4 Frames のテスト

Turbo Frames の確認は、第12章のインライン編集が代表です。

`within "##{dom_id(task)}"` で frame の中に操作を絞り、編集して保存し、その frame が表示に戻ったことを確かめます。このとき、編集フォームが消えたこと（`assert_no_field`）まで見るのが大事でした（第12章）。frame の中だけが差し替わり、ほかが動いていないことが、Frames のテストの肝です。

## 28.5 Streams のテスト

Turbo Streams の確認は、第16章・第17章が代表です。

- 作成すると、一覧の先頭にタスクが追加される（ページ遷移なし）
- 削除すると、一覧から消える
- 件数や空状態が、同時に更新される

`within "#tasks"` で一覧の中を確かめ、`assert_no_text` で削除を確かめます。複数箇所が同時に変わることを、それぞれの領域で確認します。

## 28.6 Stimulus の振る舞いを確認する

Stimulus の確認は、第20章の文字数カウンタが代表です。入力すると、文字数の表示が変わる。これはブラウザで JavaScript が動かないと起きないので、System Test で確かめます。

`fill_in` で入力し、`assert_selector` で表示が変わったことを見ます。Stimulus が要素に結びついて動いていることが、これで分かります。

## 28.7 非同期更新を待つ

System Test でいちばん大事なのが、非同期更新の待ち方です。Hotwire の更新は、リクエストの往復を挟むので、操作した瞬間には終わっていません。

ここで `sleep` を使ってはいけません。待ち時間は環境で変わり、長すぎれば遅く、短すぎれば失敗するからです。

代わりに、Capybara の待つマッチャを使います。`assert_selector` や `assert_text`、`assert_no_text` は、条件が満たされるまで（既定の待ち時間まで）自動で待ち、再試行します。

```ruby
click_on "Create Task"
within "#tasks" do
  assert_text "新しいタスク"   # 追加されるまで自動で待つ
end
```

`assert_text` が、タスクが追加されるまで待ってくれます。削除の確認も、`assert_no_text` が「消えるまで待つ」ので、`sleep` は要りません。

## 28.8 壊れやすいテストを避ける

最後に、フレーク（不安定なテスト）を避ける勘所です。

- <strong>更新の前に assert しない</strong>。操作の直後、待つマッチャを使わずに値を読むと、まだ更新前で偶然通ったり落ちたりします。必ず、待つマッチャ（`assert_selector` など）で「変わったこと」を確かめます。
- <strong>broadcast は同期して確かめる</strong>。Action Cable のリアルタイム更新（第18章）は、配信が非同期になりがちで、System Test では特に不安定です。配信の中身（どんな Turbo Streams を流すか）は、モデルやリクエストのテストで確かめ、System Test では「2 つのセッション（Capybara の `using_session`）を開いて、片方の操作がもう片方に反映される」ような結合だけに絞ると、安定します。非同期ジョブ（`*_later`）を使うなら、テストでジョブを実行させてから確かめます。

> 第28章では、テストを層で配分し、Hotwire の結合を System Test で守る戦略を立てました。次の第29章では、テストでは捉えきれない不具合を追うための、デバッグとイベント観察の道具を整えます。

## 参考資料

- Rails ガイド「テスティング」: <https://guides.rubyonrails.org/testing.html>
- Rails ガイド「システムテスト」: <https://guides.rubyonrails.org/testing.html#system-testing>
- Turbo Handbook: <https://turbo.hotwired.dev/handbook/introduction>
