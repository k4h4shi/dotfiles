---
name: subagent-retrospective
description: "セッションのレトロスペクティブをCodexサブエージェントに依頼する。Usage: /subagent-retrospective [SESSION_ID]"
allowed-tools: Bash
---

# サブエージェントレトロスペクティブ（Codex）

このスキルは、`codex` CLI 経由で外部のCodexエージェントにセッション分析を委譲する。

## 手順

1.  **セッションIDを特定**:

    - ユーザーが指定していればそれを使う（`$ARGUMENTS`）
    - 指定がなければ空のまま（Codex側で最新セッションを自動検出）

2.  **Codexを呼び出す**:

    - `codex` コマンドでレトロスペクティブを実行する
    - **コマンド**:
      ```bash
      # セッションID指定あり
      codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
        --output-last-message - \
        "/session-retrospective <SESSION_ID>"

      # セッションID指定なし（最新セッションを自動検出）
      codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
        --output-last-message - \
        "/session-retrospective"
      ```

3.  **報告**:
    - Codexにレトロスペクティブ依頼を送ったことをユーザーに伝える
    - 生成されたレポートのパスを案内する（`~/.claude/retrospectives/`）
