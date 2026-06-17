# 付録B Turbo 属性・イベント一覧

本書で扱った Turbo の主な属性・meta タグ・イベントを、引きやすいようにまとめます。網羅的な一覧と最新の仕様は、公式リファレンスで確認してください。

- Turbo 属性リファレンス: <https://turbo.hotwired.dev/reference/attributes>
- Turbo イベントリファレンス: <https://turbo.hotwired.dev/reference/events>

## 主な data 属性

| 属性 | 役割 | 主な登場章 |
| --- | --- | --- |
| `data-turbo="false"` | 要素や範囲で Turbo を無効化する（内側で `"true"` に戻せる） | 第7章 |
| `data-turbo-track="reload"` | 追跡対象のアセットが変わったらフルリロードする | 第7章 |
| `data-turbo-action="advance"` | frame の差し替えで URL も更新する | 第14章・第23章 |
| `data-turbo-frame` | リンク／フォームの差し替え先 frame を指定（`_top` でページ全体） | 第11章 |
| `data-turbo-permanent` | ページが変わっても要素を保持する（`id` が必要） | 第9章 |
| `data-turbo-temporary` | キャッシュ前に要素を取り除く（プレビューに残さない） | 第9章 |
| `data-turbo-confirm` | 操作前に確認ダイアログを出す | 第10章 |
| `data-turbo-method` | リンクのリクエストメソッドを変える | 第10章 |
| `data-turbo-stream` | GET でも Turbo Streams を受け取る（opt-in） | 第15章・第24章 |
| `data-turbo-submits-with` | 送信中の送信ボタンの文言を差し替える | 第25章 |

## 主な meta タグ

| meta タグ | 役割 | 主な登場章 |
| --- | --- | --- |
| `<meta name="turbo-refresh-method" content="morph">` | page refresh を morph で行う（既定 `replace`） | 第9章 |
| `<meta name="turbo-refresh-scroll" content="preserve">` | page refresh でスクロール位置を保つ（既定 `reset`） | 第9章 |
| `<meta name="turbo-cache-control" content="no-cache">` | ページをキャッシュしない | 第9章 |
| `<meta name="turbo-cache-control" content="no-preview">` | プレビュー表示だけ止める | 第9章 |

## 主なイベント（すべて `document` で発火）

| イベント | タイミング | 主な登場章 |
| --- | --- | --- |
| `turbo:click` | Turbo 有効なリンクをクリックした | 第10章 |
| `turbo:before-visit` | visit を始める直前（`preventDefault` で中断可） | 第10章 |
| `turbo:visit` | visit を始めた | 第10章 |
| `turbo:before-render` | 新しい body を描画する直前 | 第10章 |
| `turbo:render` | 描画した | 第10章 |
| `turbo:load` | ページ読み込みが完了した（初回と各 visit 後） | 第10章 |
| `turbo:before-cache` | スナップショットを保存する直前 | 第9章 |
| `turbo:submit-start` | フォーム送信が始まった | 第10章・第25章 |
| `turbo:submit-end` | フォーム送信が終わった（`detail.success` を含む） | 第10章 |
| `turbo:frame-load` | frame の読み込みが完了した | 第29章 |
| `turbo:frame-render` | frame を描画した | 第29章 |
| `turbo:before-morph-element` | 要素を morph する直前（`preventDefault` でスキップ可） | 第10章 |
| `turbo:morph` | morph が終わった | 第10章 |

> 値の正確な指定や、ここに載せていない属性・イベントは、必ず公式リファレンスで確認してください。Turbo のバージョンによって追加・変更されることがあります。
