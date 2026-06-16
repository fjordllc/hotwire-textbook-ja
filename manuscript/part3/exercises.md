# ハンズオン（第3部）: 通常の CRUD を Turbo Drive で動かす

第2部で作った素の CRUD に対して、Turbo Drive の挙動を契約どおりに整えます。

## この部の到達状態

- リンク遷移が visit（body 差し替え＋ head マージ）として高速に動く
- フォーム送信が「成功は redirect、失敗は 422 再描画」に統一されている
- `data-turbo-track="reload"` で、アセット更新時だけフルリロードがかかる
- progress bar が出る
- プロジェクト削除前に `data-turbo-confirm` で確認が出る

## 作る・変える

1. controller のステータスコードを契約どおりに整える（`update` / `destroy` は `status: :see_other`、失敗は 422）
2. 確認ダイアログとローディング表示を足す
3. キャッシュとプレビューの挙動を観察する

## 完成条件

- 無効な Task で 422 が返り、フォームがエラー付きで残る
- 作成成功で詳細へ遷移する
- これらを System Test で確認できる

## Relay の現在地

**遷移とフォームの土台が契約どおりに動く状態。** 次の第4部で、ページの一部だけを更新する Turbo Frames に進みます。
