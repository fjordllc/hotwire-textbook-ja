# 全文レビューの修正対応（2026-10-09）

前回の90項目を、原稿・図版・Relay の参照実装へ反映するための対応表です。章途中の例と完成版を区別し、完成版コードは `manuscript/snippets/` から取り込みます。公開先への commit / push / deploy はこの作業に含みません。

| 番号 | 指摘 | 修正箇所・対応 |
| --- | --- | --- |
| 1 | root 未定義 | 第5章、Relay routes に tasks#index |
| 2 | enum に整数文字列を送信 | 第5章、select と validate:true |
| 3 | current_user がない | 第5・27・31章、authenticated? / Current.user |
| 4 | System Test の認証 | 第5章、共通基底でログイン |
| 5 | テストの dom_id | 基底に RecordIdentifier を include |
| 6 | flash partial の定義が遅い | 第5章で作成、レイアウトに集約 |
| 7 | index 書き換えで @task 消失 | 第23・24章と完成版で維持 |
| 8 | new 単独ページの送信 | page / inline を分け、HTML fallback |
| 9 | update / destroy の stream 分岐不足 | 第16章で両アクションの全体を掲載 |
| 10 | 削除操作の UI 不足 | 第12章、共通 partial、確認ダイアログ |
| 11 | @project 未定義の購読 | 第18章実験は projects/tasks_panel に限定 |
| 12 | 検索条件がページ送りで消える | filtered_tasks と query_parameters を共用 |
| 13 | mutation に一覧条件が渡らない | 第17・18・23章、完成版は閲覧側で再取得 |
| 14 | 空から作成しても空表示が残る | 第17章で create も全体置換、完成版は再取得 |
| 15 | 配信で最後の一件を消す | 完成版で空状態を含むフレームを再取得 |
| 16 | 行配信が検索・ページ分割と不整合 | 実験の適用範囲を限定、完成版は変更通知 |
| 17 | 所属変更の旧プロジェクトに残る | 全体へデータを含まない通知、各条件で再取得 |
| 18 | 他ユーザーの編集中フォームを破壊 | data-editing / dialog を確認し手動更新へ |
| 19 | タブのルート不足 | 第13・26章にルート・アクション・ビュー |
| 20 | Chart.js の pin / import 不一致 | 第22章、chart.js/auto の固定版を同梱 |
| 21 | observer 初期化順序 | initialize で作成、target callback で監視 |
| 22 | 次ページの target がない | 共通 pagination partial、更新後も属性を維持 |
| 23 | SQLite LIKE の ESCAPE | 第23章、明示 ESCAPE とリテラル検索テスト |
| 24 | モーダル失敗の更新先 | modal frame へ HTML 422 を返す分岐 |
| 25 | modal ID の重複 | frame 要求だけ modal を返す new ビュー |
| 26 | toast partial 未定義 | 第27章で実ファイルを掲載 |
| 27 | 詳細の見出しが古く残る | 第13章、可変タイトルを _task に集約 |
| 28 | 別案の画面が互いに衝突 | 第13章で復帰点を明記、完成版の一覧は一か所 |
| 29 | 動作確認バージョンが曖昧 | Ruby 3.3.5 / Rails 8.1.3 / 各 Gem を明記 |
| 30 | すべて visit とする説明 | 第7・8・11章、送信・Frame・Stream を区別 |
| 31 | 200 HTML の制約を一般化 | 第8・25章、Drive 非 GET に範囲を限定 |
| 32 | AI prompt の redirect と stream が矛盾 | 付録Fで応答形式ごとに分離 |
| 33 | 全イベントが document 発火 | 第10章・付録Bで発火元とバブルを区別 |
| 34 | before-visit で全離脱を止められる | 第10章で戻る・再読み込み等を除外 |
| 35 | restoration と preview の混同 | 第9・22章、付録E、図9-1 |
| 36 | no-preview で戻るの古い表示も防ぐ | 付録Eで no-cache と区別 |
| 37 | morph だけで scroll 維持 | 第9章・図9-2で preserve を別指定 |
| 38 | permanent の対応先条件 | 第9章に新旧両方の同一 ID 条件 |
| 39 | refresh method/scroll の最低版 | 第9・15章・付録Cで Turbo 8.0.21 |
| 40 | frame refresh=morph の範囲 | 第13章、明示 reload() にも適用 |
| 41 | track が CSS 本文を比較する誤解 | 第9章、タグ・指紋 URL・importmap の比較 |
| 42 | 全リンク・フォームに Drive が効く | 第7章に対象外を明示 |
| 43 | DOM 状態がどの置換でも保存される | 第21章で snapshot と新 HTML を区別 |
| 44 | 全差し替えで connect 再実行 | 第9・19・22・25章、図19-1 |
| 45 | 未宣言 target と要素なしの区別 | 第20章で undefined と Missing target を区別 |
| 46 | select の既定イベント | 付録Dを change に訂正 |
| 47 | 二重 teardown | 第22章、optional chaining と null で冪等化 |
| 48 | skeleton / d-none の CSS 不足 | 第13・21章とサンプルのスタイル |
| 49 | 開閉 button の type 不足 | 第21・26章に type=button |
| 50 | 絵文字の文字数 | 第20章、Intl.Segmenter の grapheme |
| 51 | 検索ラベルと過剰 live region | 第23章、ラベル・件数だけ status |
| 52 | IME 変換中送信 | search コントローラの composition イベント |
| 53 | 入力ごとの履歴増殖 | 第23章、検索 replace・ページ送り advance |
| 54 | 複数フォームで error ID 重複 | 第25章、context + dom_id の namespace |
| 55 | エラー概要に本文がない | フォームへ full_message の一覧 |
| 56 | tab ロールだけで操作が不足 | 通常リンクと静的タブを分離、完全な tabs 実装 |
| 57 | dropdown の Escape / menu ロール | disclosure として実装、Escape で閉じて戻す |
| 58 | dialog の名前・閉じる・フォーカス | aria-labelledby・閉じるボタン・起点への復帰 |
| 59 | flash / toast のキャッシュ復活 | 個々のメッセージに data-turbo-temporary |
| 60 | テストと主張の不一致 | 表示・HTTP・リロード・順序を別に検証 |
| 61 | 章進行で古いテストが不整合 | 第5・8・16・28章に置換点と完成版 |
| 62 | 全章でテスト掲載という未達の約束 | 第5章を主要操作のテスト方針へ修正 |
| 63 | Job / Cable / 購読準備の説明不足 | 第18章にプロセス・worker・connected の条件 |
| 64 | 全件数とページ件数の混同 | @total_count と @paged_tasks を分離 |
| 65 | 関連更新でキャッシュが古い | 第30章、関連もキーに含む別案 |
| 66 | partial 内の再帰 cache | 第30章、実表示を囲む位置を明記 |
| 67 | 認証切れ frame のログイン | 第31章、sessions/new に page_requires_reload |
| 68 | 購読後の失効説明不足 | 第31章、認可・切断・再接続拒否と教材の範囲 |
| 69 | コメント UI がない | 第16章に CRUD、フォーム、partial、配信は第18章 |
| 70 | タグ UI がない | 第23・25章に選択・許可・絞り込み |
| 71 | Outlet の reload 未定義 | 第21章に参照先の実装、検索とは別案と明記 |
| 72 | datepicker 実装なし | 第22章、固定版 flatpickr・CSS・破棄処理 |
| 73 | 演習見出し・条件と本文が不一致 | 第4・6・9部演習を実装に合わせる |
| 74 | a11y チェックリストが本文にない | 第7部演習に追加 |
| 75 | Native 手順が概要だけ | 付録Hに Swift / Kotlin / manifest / 起動手順 |
| 76 | Native の参照が循環 | 具体的なプラットフォーム別公式ページへ |
| 77 | Bridge の対応キーが誤り | 第34章、static component と識別子を区別 |
| 78 | context / presentation の混同 | 第33章・第9部演習・図33-1 |
| 79 | WebView と外部ブラウザの cookie 共有 | 第32章・付録Hで保存先と認証方式を区別 |
| 80 | Simulator / 実機の接続設定なし | 付録Hに bind、接続先、HTTP 開発設定 |
| 81 | 旧来の全遷移を白画面・全再転送と断定 | 第7章・図7-1、HTTP cache と bfcache |
| 82 | Hotwire 未使用と標準 Drive の矛盾 | 第5章、カスタマイズ前の標準 Drive と説明 |
| 83 | 手書き ID 全面禁止 | 第17章・図17-1、レコードと固定コンテナを区別 |
| 84 | seed の完全再現を断定 | 第5章・README、乱数・日付・既存パスワード |
| 85 | 生成前にモデル編集 | 第5章で生成→関連編集へ並べ替え |
| 86 | 他書比較・未来形の前書き | 前書き・README を本書だけで説明 |
| 87 | controller の用語不統一 | コード・識別子を保持し、本文をコントローラへ |
| 88 | 図版ディレクトリが誤り | README を assets / scripts/figures/src に訂正 |
| 89 | 図24-1 / 10-1 の仕様違い | 追記の URL 再現性△、中断可能イベントを訂正 |
| 90 | 本番品質の過大な断定 | 教材の範囲・残る運用設計・未検証範囲を明記 |

## 検証の範囲

以下を実行し、成功を確認しました。

- `mdbook build`。
- 原稿70ファイルのローカル参照、コードフェンス210個、JSON例、SVG46個の構文検査。
- 完成版コード28ファイルと `/Users/machida/dev/relay` の一致。
- Rails のモデル・リクエスト・統合テスト：36件、113検証、失敗ゼロ。
- Chrome の System Test：11件、85検証、失敗ゼロ。検索後の通知、連続更新、未保存入力の保護、ページ送り・追記・自動読み込み、モーダル、コメント、外部ライブラリを含みます。
- 修正対象Ruby13ファイルの RuboCop、JavaScript15ファイルの構文検査。

テストはサンプルの一時作業コピーで実行し、変更58ファイルをサンプル本体へコピーした後、内容の一致をハッシュで検証しました。Native は公式資料との照合と設定例の整備であり、iOS / Android の実機ビルド・ストア配布は確認していません。書籍全ページの目視確認は行っていません。
