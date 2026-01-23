---
name: subagent-review
description: PRのコードレビューをCodexサブエージェントに依頼する。ユーザーがレビュー依頼/コード確認/「review」と言及したときに使う。
allowed-tools: Bash
---

# サブエージェントレビュー

このスキルは、外部のAIエージェント（Codex または Gemini）にコードレビューを委譲する。
**デフォルトは Codex CLI** を使用する。

## 手順

ユーザーがレビューを依頼した場合（例:「PR #123レビューして」「これレビューして」）は次の手順で進める。

1.  **PR番号を特定**:

    - ユーザーが番号を指定していればそれを使う
    - 指定がなければ `gh pr view --json number -q .number` で現在のPR番号を取得する

2.  **レビュワーを選択**:

    - **デフォルト**: Codex CLI
    - ユーザーが「Gemini」を指定した場合: Gemini CLI

3.  **サブエージェントを呼び出す**:

    ### Codex（デフォルト）

    ```bash
    codex "/review <PR_NUMBER>" --full-auto
    ```

    ### Gemini（ユーザー指定時）

    ```bash
    gemini "/review <PR_NUMBER>" --yolo
    ```

4.  **報告**:
    - レビュー依頼を送ったことをユーザーに伝える
    - **結果は `.tmp/review_body.md` に保存される**
    - PRへの自動投稿は行われない（ユーザーが必要に応じて手動で投稿する）
