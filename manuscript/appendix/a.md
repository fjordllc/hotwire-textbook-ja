# 付録A 公式ドキュメントの歩き方

本書は、Hotwire の考え方と実践を一通り扱いました。しかし、Hotwire は動き続けます。新しい機能や、細かな仕様は、一次情報（公式ドキュメント）で確かめるのが確実です。この付録では、公式ドキュメントの歩き方を案内します。

## 一次情報の入口

Hotwire の公式情報は、次の場所にあります。

- Hotwire（全体）: <https://hotwired.dev/>
- Turbo: <https://turbo.hotwired.dev/>
- Stimulus: <https://stimulus.hotwired.dev/>
- Hotwire Native: <https://native.hotwired.dev/>
- Rails ガイド: <https://guides.rubyonrails.org/>

迷ったら、まずこの 5 つに当たります。第三者の記事は、入口としては便利ですが、情報が古いことがあります。最終的な確認は、必ず一次情報で行います。

## Handbook と Reference の違い

Turbo と Stimulus の公式ドキュメントは、大きく 2 つに分かれています。

- <strong>Handbook</strong> … 考え方と使い方を、順を追って説明します。「どう使うか」を学ぶときに読みます。本書の各章も、Handbook に対応する内容を多く含みます。
- <strong>Reference</strong> … 属性・イベント・メソッドなどを、網羅的に並べます。「正確な名前や値」を確かめるときに引きます。本書の付録B〜Dも、この Reference に対応します。

学ぶときは Handbook、確かめるときは Reference、と使い分けます。

## バージョンと変更を追う

Hotwire は更新されます。新機能（たとえば Turbo 8 の morphing）や、仕様変更を追うには、次を見ます。

- GitHub のリポジトリ（`hotwired/turbo`、`hotwired/turbo-rails`、`hotwired/stimulus`、`hotwired/hotwire-native-ios`、`hotwired/hotwire-native-android`）。リリースノートと変更履歴（CHANGELOG）で、何が変わったかを確認できます。
- 本書の方針でもあるとおり、バージョンに依存する記述を読むときは、<strong>自分が使っているバージョン</strong>を意識します。手元のバージョンは、`Gemfile.lock` や `bin/importmap json` で確認できます。

## 困ったときの調べ方

詰まったときは、次の順で当たると効率的です。

1. エラーメッセージで、Reference や付録Eを引く。
2. Handbook の該当章を読み直す。
3. GitHub の Issues / Discussions で、同じ症状を探す。
4. それでも分からなければ、最小の再現コードを作る。再現を作る過程で、原因に気づくこともよくあります。

一次情報を最優先に、確認日とバージョンを意識して調べる。これが、変化し続ける Hotwire と付き合うコツです。
