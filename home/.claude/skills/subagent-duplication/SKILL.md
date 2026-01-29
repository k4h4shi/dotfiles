---
name: subagent-duplication
description: 重複/類似コード検出（similarity-ts等があれば実行）をCodexに委譲し、責務分離/共通化の観点で要約する。Usage: /subagent-duplication
allowed-tools: Bash
---

# subagent-duplication（Codex委譲）

このスキルは、重複/類似コード検出と要約を **Codex CLI** に委譲する。

## 原則（重要）

- 重複度（類似度）は **シグナル**。目的は **適切な責務分離と共通化**、そして **コード品質（保守性/一貫性/変更容易性）**。
- 数値を下げること自体を目的にしない。

## 実行（Codex）

```bash
codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
  --output-last-message - \
  "$(cat <<'PROMPT'
You are a helper that detects duplicate/similar code in the current git repo and returns an actionable summary.

Rules:
- Do NOT edit any files. Do NOT commit. Do NOT open PRs.
- Similarity score is a signal, not a goal. Focus on responsibility boundaries and useful shared abstractions.
- Keep output concise (top few findings).

Steps:
1) Identify repo root: git rev-parse --show-toplevel
2) Choose target:
   - If web/ exists, prefer web/ (especially web/src/)
   - else use repo root
3) Detect duplicates:
   - If similarity-ts is available (command -v similarity-ts), run it against the target.
   - Otherwise return Status=skipped and provide the install hint (e.g., cargo install similarity-ts).
4) Summarize findings (top 3-5 groups):
   - Classify each as: merge-candidate / separation-candidate / intentional-dup-likely
   - Suggest \"where\" to place shared logic (Domain/Service/UI/util) and note risks.

Output format:

## Duplication Result

### Status
[pass/fail/skipped]

### Command
...

### Findings (top)
- [classification] <group summary> (suggested target: ...)

### Log excerpt (relevant)
```text
<minimal>
```
PROMPT
)"
```

