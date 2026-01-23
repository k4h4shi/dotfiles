---
name: subagent-retrospective
description: セッションのレトロスペクティブをGeminiサブエージェントに依頼する。Usage: /subagent-retrospective [SESSION_ID]
allowed-tools: Bash
---

# サブエージェントレトロスペクティブ（Gemini）

このスキルは、`gemini` CLI 経由で外部のGeminiエージェントにセッション分析を委譲する。

## 手順

1.  **セッションIDを特定**:

    - ユーザーが指定していればそれを使う（`$ARGUMENTS`）
    - 指定がなければ空のまま（Gemini側で最新セッションを自動検出）

2.  **Geminiを呼び出す**:

    - `gemini` コマンドでレトロスペクティブを実行する
    - **コマンド**:
      ```bash
      # セッションID指定あり
      gemini --include-directories "$HOME/.claude/projects" --include-directories "$HOME/.claude/debug" "/session-retrospective <SESSION_ID>" --yolo

      # セッションID指定なし（最新セッションを自動検出）
      gemini --include-directories "$HOME/.claude/projects" --include-directories "$HOME/.claude/debug" "/session-retrospective" --yolo
      ```

3.  **報告**:
    - Geminiにレトロスペクティブ依頼を送ったことをユーザーに伝える
    - 生成されたレポートのパスを案内する（`~/.claude/retrospectives/`）
