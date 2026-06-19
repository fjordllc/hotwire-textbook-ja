# おわりに

本書を最後まで読んでいただき、ありがとうございました。

本書では、チーム向けタスク管理アプリ Relay を、最初の素の CRUD から育てながら、Hotwire を一通り学びました。Turbo Drive でページ遷移を、Turbo Frames で画面の一部を、Turbo Streams で部分更新とリアルタイムを、Stimulus で振る舞いを、Hotwire Native でモバイルへの広がりを。そして、テスト・デバッグ・性能・セキュリティと、保守の観点も見てきました。

繰り返し戻ってきたのは、「HTML over the wire」という一つの考え方でした。サーバーが HTML を返し、ブラウザがそれを賢く反映する。Turbo も Stimulus も Native も、すべてこの考え方の現れです。個々の機能名や属性は忘れても、この軸さえ持っていれば、Hotwire のこれからの変化も読み解けます。

もう一つ、本書が大切にしたのは、「できる」と「保守できる」を分けて考えることでした。Hotwire は強力なので、何でも部分更新で作れてしまいます。だからこそ、「これは frame でやるべきか」「ここは通常の遷移に戻すべきか」を問い続けることが、長く付き合えるアプリにつながります。道具に振り回されず、道具を選ぶ側でいてください。

Hotwire は動き続けます。本書の内容も、いつかは古くなります。そのときは、本書で身につけた考え方を土台に、一次情報で最新を確かめてください。確認日とバージョンを意識する——本書が通して守ってきたこの姿勢が、変化の中であなたを支えてくれるはずです。

それでは、あなたのアプリで、Hotwire を活かしてください。

## FjordBootCamp について

本書は、プログラミングスクール **[FjordBootCamp（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/)** の教材として作成されました。

FjordBootCamp は、現役エンジニアが運営する日本語のオンラインプログラミングスクールです。未経験からでも学べる **Rails エンジニアコース**と**フロントエンドエンジニアコース**があり、暗記ではなく「自分で考えて学び続ける力」を育てます。本書で繰り返してきた「なぜそうなっているのかを理解する」という姿勢は、Hotwire に限らず、これからの学習すべてで効いてきます。

もっと体系的に、仲間やメンターと一緒に学びたくなったら、ぜひのぞいてみてください。

- 公式サイト: <https://bootcamp.fjord.jp/>

## 主要な一次情報

最後に、実務で何度も戻ることになる主要な一次情報を挙げます。

- [Hotwire（公式トップ）](https://hotwired.dev/)
- [Turbo Handbook](https://turbo.hotwired.dev/)
- [Stimulus Handbook](https://stimulus.hotwired.dev/)
- [Hotwire Native](https://native.hotwired.dev/)
- [Rails ガイド](https://guides.rubyonrails.org/)
- [完成版サンプルアプリ Relay](https://github.com/fjordllc/Relay)

## ライセンス

本書の本文・原稿は、MIT License で公開されています。

Copyright (c) 2026 FjordBootCamp
