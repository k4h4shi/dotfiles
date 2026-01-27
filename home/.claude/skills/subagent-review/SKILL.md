---
name: subagent-review
description: ローカル差分 or PR のレビューを subagent（Codex/Gemini）に委譲する。コミット前は local、PRがあるなら pr を使う。Usage: /subagent-review [local|pr] [PR_NUMBER] [codex|gemini]
allowed-tools: Bash
---

# サブエージェントレビュー

このスキルは、外部のAIエージェント（Codex または Gemini）にコードレビューを委譲する。
**デフォルトは Codex CLI** を使用する。

## 使い分け（重要）

- **コミット前（ローカル差分レビュー）**: `/subagent-review local`
- **PRレビュー（PR番号がある）**: `/subagent-review pr <PR_NUMBER>`
- 引数が省略された場合は **auto**（PRが取れればPR、取れなければlocal）として扱う

## 手順

ユーザーがレビューを依頼した場合（例:「レビューして」「PR #123レビューして」）は次の手順で進める。

1.  **モードを決める**:

- `local` / `pr` / `auto`（デフォルト）で決める
- `auto` の場合は `gh pr view --json number -q .number` を試し、取れれば `pr`、取れなければ `local`

2.  **レビュワーを選択**:

    - **デフォルト**: Codex CLI
    - ユーザーが「Gemini」を指定した場合: Gemini CLI

3.  **サブエージェントを呼び出す**:

    ### Codex（デフォルト）

    ```bash
    # 結果は stdout に返す（ファイル経由にしない）
    codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
      --output-last-message - \
      "<PROMPT>"
    ```

    ### Gemini（ユーザー指定時）

    ```bash
    gemini "<PROMPT>" --yolo
    ```

4.  **報告**:
    - レビュー依頼を送ったことをユーザーに伝える
    - **結果は標準出力で返る**（必要ならユーザーが任意のファイルにリダイレクトして保存する）
    - PRへの自動投稿は行われない（ユーザーが必要に応じて手動で投稿する）

## PROMPT テンプレ

### local（コミット前のローカル差分レビュー）

```text
You are reviewing local changes in the current git repo (no PR yet).

1) Run: git status -sb
2) If there are staged changes, review staged diff: git diff --staged
   Otherwise review working tree diff: git diff
3) Identify: (a) must-fix, (b) risks/edge cases, (c) optional improvements.
4) Keep output concise and actionable.
```

### pr（PRレビュー）

```text
/review <PR_NUMBER>
```
