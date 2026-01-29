---
name: subagent-coverage
description: coverage（あれば）を実行し、結果を「不足テスト観点」に翻訳して返す。数値追跡ではなくテストカバレッジ/有効性に寄せる。Usage: /subagent-coverage
allowed-tools: Bash
---

# subagent-coverage（Codex委譲）

このスキルは、coverage 実行と結果要約を **Codex CLI** に委譲する。

## 原則（重要）

- コードカバレッジは **シグナル**。目的は **不足テスト観点の発見**（テストカバレッジ/テスト有効性の向上）。
- 数字を上げること自体を目的にしない。

参考: [コードカバレッジ vs. テストカバレッジ vs. テスト有効性](https://www.qt.io/ja-jp/blog/code-coverage-vs.-test-coverage-vs.-test-effectiveness-what-do-you-measure)

## 実行（Codex）

```bash
codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
  --output-last-message - \
  "$(cat <<'PROMPT'
You are a helper that runs coverage (if available) in the current git repo and summarizes results as missing test ideas.

Rules:
- Do NOT edit any files. Do NOT commit. Do NOT open PRs.
- Coverage % is a signal, not a goal. Translate findings into test coverage / test effectiveness improvements.
- Keep output concise.

Steps:
1) Identify repo root: git rev-parse --show-toplevel
2) Determine a coverage command:
   - Prefer documented commands in AGENTS.md / docs.
   - If there is web/package.json with script \"test:coverage\", run: cd web && npm run test:coverage
   - Else, if package.json has \"test:coverage\" or \"coverage\", run it from the correct dir.
   - If no coverage command exists, return Status=skipped and explain what was searched.
3) Locate lcov file(s) (examples):
   - coverage/lcov.info
   - web/coverage/lcov.info
4) Summarize \"low coverage -> missing test ideas\" (top 3-5):
   - Use file + uncovered line ranges as evidence (signal).
   - For each file, propose 1-2 test ideas focusing on risk: error handling, branches, boundary values, auth/permission, state transitions/concurrency, SSOT scenarios.

Output format:

## Coverage Result

### Status
[pass/fail/skipped]

### Command
...

### Artifact
- lcov: <path or none>

### Low coverage -> test ideas (top)
- <file>: lines <ranges> -> <missing test idea>

### Log excerpt (if failed)
```text
<minimal>
```
PROMPT
)"
```

