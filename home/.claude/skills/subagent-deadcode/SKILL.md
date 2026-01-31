---
name: subagent-deadcode
description: デッドコード検出をCodexに委譲する。Usage: /subagent-deadcode
allowed-tools: Bash
---

# サブエージェントデッドコード検出（Codex委譲）

このスキルは、`codex` CLI 経由で外部のCodexエージェントにデッドコード検出を委譲する。

## 原則（重要）

- デッドコード検出は **シグナル**。目的は **不要コードの特定と安全な削除**、そして **コード品質（可読性/保守性/ビルド時間短縮）**。
- 検出されたコードを機械的に削除しない。意図的に残しているコード（将来利用予定、フラグ切替等）を確認する。

## 手順

1. **Codexを呼び出す**:

   ```bash
   codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
     --output-last-message - \
     "/deadcode"
   ```

2. **報告**:
   - Codexにデッドコード検出を依頼したことをユーザーに伝える
   - 結果は標準出力で返る
