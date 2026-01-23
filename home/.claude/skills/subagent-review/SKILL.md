---
name: subagent-review
description: PRのコードレビューをGeminiサブエージェントに依頼する。ユーザーがレビュー依頼/コード確認/「review」と言及したときに使う。
allowed-tools: Bash
---

# サブエージェントレビュー（Gemini）

このスキルは、`gemini` CLI 経由で外部のGeminiエージェントにコードレビューを委譲する。

## 手順

ユーザーがレビューを依頼した場合（例:「PR #123レビューして」「これレビューして」）は次の手順で進める。

1.  **PR番号を特定**:

    - ユーザーが番号を指定していればそれを使う
    - 指定がなければ `gh pr view --json number -q .number` で現在のPR番号を取得する

2.  **Geminiを呼び出す**:

    - `gemini` コマンドでレビュー指示を実行する
    - 可能なら `--yolo`（安全に使える前提）または対話モードで確実に実行する
    - **コマンド**:
      ```bash
      gemini "/review <PR_NUMBER>" --yolo
      ```

3.  **報告**:
    - Geminiにレビュー依頼を送ったことをユーザーに伝える
