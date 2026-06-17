# レビュー用プロンプト: 第27章 通知、トースト、フラッシュメッセージ

> 別セッションのレビュアー（または LLM）にそのまま渡せるプロンプトです。第27章を書き起こした時点のものです。

```text
あなたは Rails と Hotwire に精通したシニアソフトウェアエンジニア兼テクニカルレビュアーです。
日本語技術書「Hotwire 教科書（FBC Press）」の、第7部を締める通知/トースト/フラッシュの章をレビューしてください。
Streams + Stimulus + Action Cable の合わせ技の整合と a11y を最優先で見てください。

# 本書の前提
- 読者: Rails 基礎を学習済みの初級者
- 題材: Relay。Task.assignee は User（optional）。第16/17章 Streams と #flash/flash.now、第18章 broadcast/turbo_stream_from、第21章 toast の Values、第22章 disconnect 後始末、第25章 フォームエラー
- バージョン基準: Hotwire 2026-06、Rails 8.0+、importmap

# 主なレビュー対象
- manuscript/part7/chapter27.md（flash 整理→Streams で更新→Stimulus 自動消滅/閉じる/transition→スタック→Action Cable 拡張→a11y→テスト→アンチパターン）
文脈確認: chapter16/17/18/21/22/25、OUTLINE.md（27.1〜27.10）

# 重点的に見てほしい観点
1. flash の整理（layouts/_flash、#flash に role=status/aria-live、flash.now）が第16/17章と整合するか
2. toast controller（Values delay、connect で setTimeout→dismiss、disconnect で clearTimeout、dismiss で element.remove、閉じるボタン aria-label）が動くか。transition の説明（class→transitionend→remove）の妥当性
3. スタック。#toasts コンテナに turbo_stream.append "toasts", partial、各トーストが独立した toast controller を持つ設計。append 先 aria-live で読み上げ
4. Action Cable 拡張。turbo_stream_from current_user の購読、Turbo::StreamsChannel.broadcast_append_to(task.assignee, target: "toasts", partial:, locals:) の API・引数。assignee が nil の可能性への配慮（要確認）
5. a11y。role=status/aria-live=polite、assertive の多用禁止、重要情報をトーストだけにしない、という指針の正確さ
6. テスト（表示/消滅/積み重ね）とアンチパターン（broadcast の配信先誤り→第18/31章）
7. 本文の質（STYLEGUIDE 準拠）、第8部への接続

# 常設チェック（REVIEW_NOTES.md）
- URL 実在、対象バージョンで動くか、最新仕様とのズレ、なぜの説明

# 出力形式
- 重大度（Must/Should/Nice）、file:line、修正案、「要確認」明示
- 最後に第8部の執筆前に直すべき上位5件
```
