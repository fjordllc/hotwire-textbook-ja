# 第3章 なぜ Rails と Hotwire は相性がよいのか

## この章のねらい

第2章で、HTML over the wire という考え方を見ました。この考え方は、Rails ととりわけ相性がよいものです。それは偶然ではありません。Hotwire は、Rails の作者たちが生み出したものだからです。

この章では、Rails のどの仕組みが Hotwire とどうつながるのかを整理します。第1部の締めとして、第2部以降の地図にします。

## 3.1 Rails はもともと HTML を返すフレームワークである

Rails は、登場したときから、サーバーで HTML を組み立てて返すフレームワークでした。controller がデータを用意し、view（ERB など）が HTML を描く。この MVC の流れは、Rails の核です。

第2章で見た「HTML over the wire」は、まさにこの Rails の基本そのものです。Hotwire は、Rails に新しい思想を持ち込むのではなく、<strong>Rails がもともと得意なこと（HTML を返す）を、現代的な部分更新へ自然に延長する</strong>ものです。だから、両者は無理なく噛み合います。

## 3.2 partial と Turbo の相性

Rails には、view の一部を切り出して再利用する partial があります。`_task.html.erb` のように、画面の部品を partial にまとめておく書き方です。

この partial が、Turbo と抜群に相性がよいのです。Turbo Frames や Turbo Streams で部分更新するとき、更新する HTML は、たいてい partial で作ります。一覧の最初の表示でも、部分更新でも、同じ partial を使えます。Rails 開発者がふだん書いている partial が、そのまま Hotwire の部品になります（本書では第12章以降で実際に使います）。

## 3.3 RESTful controller と Turbo Streams

Rails は、REST に沿った controller を勧めます。`index`・`show`・`new`・`create`・`edit`・`update`・`destroy` という、おなじみの 7 つのアクションです。

Hotwire は、この RESTful な作りの上に、素直に乗ります。たとえば、`create` で作成したら一覧に追加する、`destroy` で削除したら一覧から消す、といった部分更新は、Turbo Streams で表現できます。普通の RESTful controller を、少し拡張するだけで、画面遷移のない更新になります（第5部で扱います）。新しい設計を覚え直すのではなく、いつもの controller の延長です。

## 3.4 Action Cable とリアルタイム更新

Rails には、WebSocket を扱う Action Cable があります。サーバーからブラウザへ、リアルタイムにデータを押し出す仕組みです。

Hotwire は、これと組み合わさります。あるユーザーの操作をきっかけに、サーバーが Turbo Streams の命令を Action Cable で配信すると、それを購読している全員の画面が、リアルタイムに更新されます。リアルタイム機能を、特別な JavaScript をほとんど書かずに作れます（第18章で扱います）。Rails の既存の仕組みが、そのまま活きます。

## 3.5 Hotwire を使うときの Rails 設計の変化

Hotwire を使っても、Rails の基本は変わりません。MVC、REST、partial、Action Cable。これまでの知識が、そのまま土台になります。

変わるのは、設計の意識です。

- view を、部分更新しやすいように partial へ分けることを、より意識します。
- controller のレスポンスを、HTML だけでなく Turbo Streams でも返せるように考えます。
- 要素の `id` を、`dom_id` で一貫させ、部分更新の宛先にします。

どれも、Rails の作法から大きく外れるものではありません。「いつもの Rails を、部分更新に向く形に少し整える」。それが、Hotwire を使うときの設計の勘所です。本書は、この勘所を、Relay を育てながら身につけていきます。

> 第1部はここまでです。Hotwire を設計思想として捉え、その背景と、Rails との相性を見ました。次の第2部では、いよいよ手を動かします。本書を通して育てるサンプルアプリ Relay の仕様を決め、その土台を作ります。

## 参考資料

- Rails ガイド: <https://guides.rubyonrails.org/>
- Rails ガイド「レイアウトとレンダリング」: <https://guides.rubyonrails.org/layouts_and_rendering.html>
- Rails ガイド「Action Cable の概要」: <https://guides.rubyonrails.org/action_cable_overview.html>
- Hotwire: <https://hotwired.dev/>
