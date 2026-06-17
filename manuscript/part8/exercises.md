# ハンズオン（第8部）: System Test で Hotwire UI を検証する

第7部までに作った Relay を、テスト・性能・セキュリティの面から固めます。

## この部の到達状態

- 主要フローを覆う System Test 一式がある
- `assignee` / `tags` / `comments` の N+1 を `includes` で解消してある
- broadcast の配信先を controller / model 側で絞り、購読は署名付き stream 名で行っている（署名は購読名の改ざん防止であって認可ではない）
- 「Network → Turbo イベント → Stimulus → target id」の順で原因を切り分けられる

## 作る・変える

1. テスト戦略に沿って層を配置し、フレークしない System Test を書く
2. N+1 をログで計測してから解消する
3. broadcast の配信先を controller / model 側で絞り、購読に署名付き stream 名を使う

## 完成条件

- テストスイートがフレークなしで緑になる
- N+1 がログから消える
- 他ユーザーに見せてはいけない更新が broadcast されない

## Relay の現在地

<strong>Relay が壊れにくく・速く・安全になった状態。</strong> 次の第9部で、同じ Relay をモバイルへ広げます。
