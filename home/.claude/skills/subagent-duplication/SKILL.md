---
name: subagent-duplication
description: 重複/類似コード検出をCodexに委譲する。Usage: /subagent-duplication
allowed-tools: Bash
---

# サブエージェント重複検出（Codex委譲）

このスキルは、`codex` CLI 経由で外部のCodexエージェントに重複検出を委譲する。

## 原則（重要）

- 重複度（類似度）は **シグナル**。目的は **適切な責務分離と共通化**、そして **コード品質（保守性/一貫性/変更容易性）**。
- 数値を下げること自体を目的にしない。

## 手順

1. **Codexを呼び出す**:

   ```bash
   codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
     --output-last-message - \
     "/duplication"
   ```

2. **報告**:
   - Codexに重複検出を依頼したことをユーザーに伝える
   - 結果は標準出力で返る
