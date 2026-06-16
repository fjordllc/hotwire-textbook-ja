# ハンズオン（第6部）: モーダル、確認 UI、ソート UI を作る

サーバーとのやり取りが要らない振る舞いを、Stimulus で Relay に足します。

## この部の到達状態

- ドロップダウンメニューが Stimulus だけで開閉する
- コメント入力欄に文字数カウンタが付く
- 削除前に確認ダイアログが出る
- 自動で消えるトーストの controller が動く（表示秒数は Values で HTML から渡す）
- `due_on` の date picker（外部ライブラリ）が、Turbo 遷移・cache をまたいでも安全に動く

## 作る・変える

1. controller / action / target の基本を、文字数カウンタで覚える
2. Values / Classes / Outlets で、トーストの表示秒数・表示切り替え・UI 間連携を実装する
3. 外部ライブラリを connect / disconnect で初期化・破棄し、cleanup を入れる

## 完成条件

- ページ遷移後もドロップダウン・確認・カウンタが動く
- Turbo で画面が差し替わっても二重初期化やメモリリークが起きない

## Relay の現在地

**サーバー不要の振る舞いを Stimulus で安全に足せる状態。** 次の第7部で、ここまでの Turbo と Stimulus を組み合わせて実務 UI に仕上げます。
