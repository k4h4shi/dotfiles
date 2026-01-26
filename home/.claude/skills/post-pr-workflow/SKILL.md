---
name: post-pr-workflow
description: PR作成後の品質ゲート（レビュー/CI監視/指摘対応）をループで回す。PR作成後に使う。
allowed-tools: Bash
---

# Post-PR Workflow（Quality Assurance Loop）

PR作成後、以下のプロセスを **全て問題なくなるまで繰り返す**。

## 1. 並行タスク（サブエージェントに委譲）

以下の3つを **並行実行**する（各タスク最大15分）:

| タスク | 使用するスキル/エージェント | 内容 |
|:-------|:---------------------------|:-----|
| **Geminiレビュー** | `/subagent-review` → `review-checker` | 依頼送信 → 監視 → 指摘対応 |
| **CI監視** | `ci-debugger` エージェント | `gh pr checks --watch` → 失敗時は修正 |
| **Codexレビュー** | `review-checker` エージェント | 自動レビュー監視(10分以内) → 指摘対応 |

## 2. メインエージェント（並行で実行）

サブエージェント完了を待つ間、以下を実行:

- **整合性確認**: ドキュメント・テスト・実装の整合性をチェック
- **不整合修正**: 問題があれば修正

## 3. 完了判定

以下のコマンドで各条件をチェック:

```bash
# CI チェック
gh pr checks --json name,state,conclusion | jq -e 'all(.conclusion == "success")'

# 未解決レビューコメント
gh api repos/{owner}/{repo}/pulls/{pr}/comments --jq '[.[] | select(.position != null)] | length' | grep -q '^0$'

# 未マージのレビュー要求
gh pr view --json reviewDecision --jq '.reviewDecision' | grep -qE '^(APPROVED|null)$'
```

## 4. ループ制御

```
1. 1 の並行タスクを実行
2. 各エージェントの Output を収集
3. 変更があれば:
   - git add -A && git commit && git push
   - → 1 に戻る（最大 5 回）
4. 完了判定:
   - CI 全通過 AND 未解決コメント 0 AND レビュー承認済み or 不要
   - → 完了
5. 5 回ループしても完了しない場合:
   - 現状をユーザーに報告して判断を仰ぐ
```

