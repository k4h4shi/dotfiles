---
name: ci-debugger
description: "CIチェックを監視し、失敗時に原因特定と修正を行う。Usage: /ci-debugger [PR_NUMBER]"
---

# CI Debugger

CI チェックを監視し、失敗時はデバッグ・修正する。

## 1. CI監視（最大15分）

```bash
gh pr checks <PR_NUMBER> --watch
```

またはポーリング:

```bash
gh pr checks <PR_NUMBER> --json name,state,conclusion
```

## 2. 失敗検出時

失敗したジョブを特定:

```bash
gh run list --limit 1 --json databaseId,status,conclusion,headBranch
gh run view <RUN_ID> --log-failed
```

## 3. ローカル再現・修正

1. エラーログから原因を特定
2. ローカルで再現（lint/test/build）
3. 修正を実施（最小差分）
4. ローカルで検証
5. 修正をコミット（pushは別途）

## Output

```markdown
## CI Check Result

- 状態: [pass/fail]
- 失敗ジョブ: (あれば)
- 原因: (あれば)
- 修正: [あり/なし]
- 変更ファイル: [list]
```

