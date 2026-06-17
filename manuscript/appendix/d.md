# 付録D Stimulus リファレンス

本書で扱った Stimulus の中心要素を、引きやすいようにまとめます。最新の仕様は公式リファレンスで確認してください。

- Stimulus リファレンス: <https://stimulus.hotwired.dev/reference/controllers>

## ライフサイクルのコールバック

| コールバック | タイミング |
| --- | --- |
| `initialize()` | controller のインスタンスが作られたとき（1 度だけ） |
| `connect()` | 要素に結びついたとき（Turbo の差し替えのたびにも） |
| `disconnect()` | 要素から外れたとき |

`connect` / `disconnect` は、Turbo の visit・frame 差し替え・Streams 挿入のたびに呼ばれます（第19章）。初期化と破棄を対にします（第22章）。

## Targets

```javascript
static targets = ["field", "output"]
```

| 参照 | 意味 |
| --- | --- |
| `this.fieldTarget` | 最初の `field` target（単数） |
| `this.fieldTargets` | すべての `field` target（配列） |
| `this.hasFieldTarget` | `field` target があるか（真偽） |
| `fieldTargetConnected(el)` | `field` target が増えたとき |
| `fieldTargetDisconnected(el)` | `field` target が減ったとき |

HTML 側は `data-<identifier>-target="field"`（第20章）。

## Values

```javascript
static values = { delay: { type: Number, default: 3000 } }
```

| 参照 | 意味 |
| --- | --- |
| `this.delayValue` | 値を読む／書く |
| `delayValueChanged()` | 値が変わったとき |

型は `String` / `Number` / `Boolean` / `Array` / `Object`。HTML 側は `data-<identifier>-delay-value="..."`（複数語は `data-...-refresh-interval-value`）。第21章。

## CSS Classes

```javascript
static classes = ["hidden"]
```

`this.hiddenClass` で読みます。HTML 側は `data-<identifier>-hidden-class="..."`。クラス名を JavaScript に直書きせず HTML に置けます（第21章）。

## Outlets

```javascript
static outlets = ["list"]
```

`this.listOutlet` で、結びついた別 controller のインスタンスを参照します。HTML 側は `data-<identifier>-list-outlet="#selector"`。Outlet 先の要素が当該 controller である必要があります（Stimulus 3.2 以降、第21章）。

## Actions

HTML 側の書式は `data-action="イベント->identifier#メソッド"`。

- 既定イベントのある要素（`button` の `click`、`input` / `textarea` / `select` の `input` など）は、イベントを省ける。
- `click@window->id#method` のように `@window` / `@document` で、その対象のイベントを拾える。
- 第20章。

## 命名規則

- ファイル名 `autofocus_controller.js` → `data-controller="autofocus"`。
- サブディレクトリの `/` は `--`、語区切りの `_` は `-`。`users/list_item_controller.js` → `users--list-item`（第19章）。

> ここに載せていない API や、細かい仕様は、公式リファレンスで確認してください。
