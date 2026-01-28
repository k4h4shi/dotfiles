---
name: ci-checker
description: PRのCIチェックをwatchし、失敗時は要点＋抜粋ログだけ返す。ポーリングはしない（ghの--watchを使う）。
---

# CI Checker（スキル: スクリプト＋運用ルール）

このスキルは **「PR checks の監視（--watch）と失敗ログの抜粋」**をスクリプト化するための置き場所。
実行は `ci-checker` subagent が行い、メインには **要点＋抜粋ログ**だけ返す。

## 実行（subagent 内で）

```bash
bash ~/.claude/skills/ci-checker/scripts/watch-pr-checks.sh
```

### オプション

```bash
# PR番号を明示
bash ~/.claude/skills/ci-checker/scripts/watch-pr-checks.sh --pr 123
```

