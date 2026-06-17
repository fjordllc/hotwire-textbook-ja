# 付録F AI に Hotwire コードを依頼するときのプロンプト集

AI に Hotwire のコードを書いてもらうとき、前提を伝えないと、古いやり方や、本書と食い違う実装が返ってくることがあります。前提を添えると、精度が上がります。この付録では、依頼のコツとプロンプトの型を示します。

## 伝えるべき前提

AI への依頼には、次の前提を添えます。

- Rails と Hotwire のバージョン（例: Rails 8.0、Turbo 8 以降、importmap 構成）。
- フォームの契約（成功は redirect、`update` / `destroy` は `status: :see_other`、失敗は `status: :unprocessable_entity`）。
- 部分更新の方針（一覧の `id`、`dom_id` で宛先を揃える、partial を一覧と stream で共通化）。
- 使わない方針（jsbundling ではなく importmap、状態は HTML に置く、など）。

これらは、本書で繰り返し出てきた約束ごとです。前提として渡すと、AI の出力が本書のやり方に揃います。

## プロンプトの型

```text
Rails 8 / Turbo 8 / importmap 構成です。次の前提を守ってコードを書いてください。
- フォームの成功は redirect（update/destroy は status: :see_other）、失敗は status: :unprocessable_entity（422）。
- 部分更新は Turbo Streams。target の id は dom_id で揃える。
- 一覧と Streams で同じ partial を使う。
- JavaScript は Stimulus。状態は HTML の data 属性に置く。

依頼: <ここに作りたいものを書く（例: タスクを作成したら一覧の先頭に追加し、件数も更新する）>
出力: controller の該当アクション、turbo_stream のビュー、必要な partial、関連する Stimulus controller。
```

## レビューの観点を AI に渡す

AI が書いたコードをレビューさせるときは、本書の観点をそのまま使えます。

```text
次の Hotwire コードをレビューしてください。特に次を確認します。
- 失敗時に 422 を返しているか（200 で返していないか）。
- frame / stream の id が dom_id で表示側と揃っているか。
- broadcast の配信先が広すぎないか、秘密情報を含めていないか。
- Stimulus が disconnect で後始末しているか。
- a11y（フォーカス移動、aria-live）を踏まえているか。
```

## 注意

- AI の出力は、<strong>必ず自分で確認</strong>します。とくにバージョン依存の API（morphing 周りなど）は、古い書き方が混じりやすいので、付録B〜Dや公式リファレンスと突き合わせます。
- 動かないときは、付録Eと第29章の手順で切り分けます。AI に丸投げせず、自分が原因を追えることが、結局いちばん速い解決になります。
