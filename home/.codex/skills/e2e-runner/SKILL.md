---
name: e2e-runner
description: "E2Eテスト設計/実行フロー。Usage: /e2e-runner"
---

# E2E Runner

共通の E2E テスト設計/実行フローを提供する。

## Instructions

1. critical user flows を特定
2. E2E テストを追加/更新
3. E2E を実行し、結果を確認
4. flaky テストがあれば原因を切り分けて対処

## Output

```markdown
## E2E Test Result

### Status
[success/partial/failed]

### Summary
[何を実行したか1-2文で]

### Target Flows
- [フロー1]
- [フロー2]

### Changes
- path/to/test

### Test Result
- Total: N
- Passed: N
- Failed: N

### Failures (if any)
- [テスト名]: [失敗原因]
```

