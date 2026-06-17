# 第1章 Hotwire とは何か

## この章のねらい

本書は、Hotwire を学ぶ本です。最初の章では、Hotwire を「Rails の便利機能の寄せ集め」ではなく、一つの<strong>設計思想</strong>として捉えます。

Hotwire の全体像、それを構成する Turbo・Stimulus・Hotwire Native の役割、JSON API + SPA との違い、そして Rails に標準で入っている意味を見ます。コードはまだ書きません。考え方の地図を手に入れるのが、この章のねらいです。

## 1.1 Hotwire の全体像

Hotwire という名前は、「HTML over the wire」という考え方に由来します。その名のとおり、<strong>サーバーが HTML を生成して送り、ブラウザがそれを賢く反映する</strong>、という考え方です（wire ＝通信路を、HTML が流れるイメージです）。

近年の Web アプリケーションの多くは、サーバーが JSON を返し、ブラウザ側の JavaScript が画面を組み立てる、という作りでした。Hotwire は、そこに一石を投じます。「画面は HTML なのだから、サーバーが HTML を送ればよいではないか」。この素朴な発想を、現代的な使い勝手で実現するのが Hotwire です。

ページ全体を毎回作り直すのではなく、必要な部分の HTML だけを送り、滑らかに差し替える。JavaScript は、必要なところに少しだけ足す。こうして、SPA のような体験を、サーバー中心のまま実現します。

## 1.2 Turbo / Stimulus / Hotwire Native の役割

Hotwire は、いくつかの道具の集まりです。役割が分かれています。

- <strong>Turbo</strong> … HTML の送受信と画面更新の中心です。ページ遷移を速くする Turbo Drive、ページの一部を独立して扱う Turbo Frames、部分更新の命令を送る Turbo Streams からなります。本書の第3部〜第5部で扱います。
- <strong>Stimulus</strong> … HTML に、少しの JavaScript で振る舞いを足す道具です。サーバー往復の要らない操作（開閉、入力補助など）を担います。第6部で扱います。
- <strong>Hotwire Native</strong> … Web の画面を、そのまま iOS / Android のモバイルアプリへ広げる道具です。第9部で扱います。

Turbo が屋台骨、Stimulus が補助、Hotwire Native がモバイルへの拡張、という関係です。どれも「HTML over the wire」という一つの考え方の現れです。

## 1.3 JSON API + SPA との違い

Hotwire の位置づけは、JSON API + SPA と比べると、はっきりします。

SPA（Single Page Application）では、サーバーは JSON を返し、ブラウザの JavaScript が、その JSON から画面を組み立てます。画面の状態は、主にブラウザ側に持ちます。リッチな操作ができる一方、JavaScript の量が増え、状態の管理が複雑になりがちです。

Hotwire では、サーバーが HTML を返します。画面を組み立てるのは、主にサーバーです。状態も、基本はサーバー（と HTML）が持ちます。JavaScript は最小限で済みます。

どちらが優れている、という話ではありません。向き不向きがあります（第10部で詳しく比較します）。多くの業務アプリのように、サーバーが持つデータを見せ、操作するのが中心なら、Hotwire は素直で保守しやすい選択肢になります。

## 1.4 Rails に標準で入っている意味

Hotwire は、Rails の既定です。`rails new` で新しいアプリを作ると、最初から Turbo と Stimulus が入っています。

これは、ただの同梱以上の意味を持ちます。Rails はもともと、サーバーで HTML を返すフレームワークです（第3章で詳しく見ます）。その Rails が、画面更新の標準的なやり方として Hotwire を選びました。つまり、Hotwire は Rails の思想と地続きであり、Rails を使うなら最初に手が届く選択肢だ、ということです。

本書が Hotwire を扱うのも、この理由からです。新しいライブラリを追加して身につけるのではなく、すでにそこにあるものを理解する。それが、Rails 開発者にとっての Hotwire です。

## 1.5 本書で作るサンプルアプリの見取り図

本書では、説明だけでなく、手を動かして学びます。題材は、チーム向けタスク管理アプリ <strong>Relay</strong>（仮称）です。

Relay は、プロジェクトの下にタスクがぶら下がり、タスクにステータス・担当者・タグ・コメントが付く、という構成です。最初は、ごく普通の Rails の CRUD アプリとして作ります。そこから、検索、インライン編集、リアルタイム更新、モーダル、通知といった機能を、Hotwire で段階的に足していきます。

一つのアプリを最初から最後まで育てるので、「この機能を、なぜこの道具で作るのか」を、文脈の中で理解できます。Relay の詳しい仕様は、第2部（第4章）で共有します。

> 第1章では、Hotwire を「HTML over the wire」という設計思想として捉えました。次の第2章では、なぜ今、HTML を送る設計が見直されているのか、その背景を歴史から見ます。

## 参考資料

- Hotwire: <https://hotwired.dev/>
- Turbo: <https://turbo.hotwired.dev/>
- Stimulus: <https://stimulus.hotwired.dev/>
- Hotwire Native: <https://native.hotwired.dev/>
