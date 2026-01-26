---
name: refactor-cleaner
description: "安全なクリーンアップ/リファクタの共通フロー。Usage: /refactor-cleaner"
---

# Refactor Cleaner

共通の安全なクリーンアップ/リファクタフローを提供する。

## Instructions

1. 未使用/重複コードを特定
2. 小さく安全なステップで削除/整理
3. 各ステップでテストを再実行

## Safety Rules

- 変更は小さく分割
- テストを必ず再実行

## Output

```markdown
## Refactor Result

### Status
[success/partial/failed]

### Summary
[何をクリーンアップしたか1-2文で]

### Changes
- path/to/file: [変更内容]

### Test Result
[pass/fail]
```

