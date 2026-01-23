---
description: "Implement a feature or fix a bug following TDD in a dedicated worktree. Usage: /fix [ISSUE_NUMBER]"
---

# Implement Issue (Common Command)

This command defines a **common interface**. Project-specific behavior is provided by skills with the same names.

## 1. Preparation (Task Setup)

1.  **Understand the Requirement**: Read the issue and the project's docs.
2.  **Worktree is created by Vive** for the task.
    - If it does not exist, refer to the `worktree-management` skill and create it.
3.  **Switch Context**:
    - Change directory to the task's worktree.
    - **IMPORTANT**: All subsequent commands must be run INSIDE this worktree directory.
4.  **Project Initialization** (if needed):
    - **New worktree**: Run `environment-setup` skill (deps/DB/env).
    - **Existing worktree**: Skip if `.env` exists and deps are installed.

### 1.1 環境構築後の確認（アイドリング防止）

`environment-setup` 完了後、**必ず以下を確認してから次に進む**:

| 確認項目 | コマンド例 | 問題時の対処 |
|----------|-----------|-------------|
| 開発サーバー起動 | `npm run dev` / `pnpm dev` | ログを確認、依存関係を再インストール |
| ポート競合 | `lsof -i :3000` | `kill -9 <PID>` または `.env` でポート変更 |
| DB接続 | `docker compose ps` / `pg_isready` | コンテナ起動、認証情報確認 |
| スキーマ適用 | `npx prisma migrate status` | `npx prisma migrate dev` |
| テスト実行 | `npm test` | エラーログを確認 |

**確認完了後、即座に Section 2 (Planning & Design) に進むこと。**

## 2. Planning & Design (Self-Correction)

**Before coding**, ask yourself: "Do I have a clear plan?"

- If the implementation is complex or touches multiple layers:
  - **Invoke the `planner` agent**.
  - Ask it to generate an implementation plan based on project docs and architecture rules.
  - Review the plan.

## 3. Implementation Flow (TDD)

Follow the TDD cycle with the `tdd-runner` agent.

### Step 0: Create Test List
### Step 1-4: Red -> Green -> Refactor

- **Note**: Use the `tdd-runner` agent to guide this process.
- **Build Errors**: If you encounter build or type errors:
  - **Use the `ci-debugger` agent**.
  - Let it fix the compilation issues with minimal changes.

## 4. Final Verification & Documentation

When implementation is complete, **BEFORE** attempting to finish:

1.  **MANDATORY: Update Documentation**:
    - **Use the `doc-updater` agent**. This is NOT optional.
    - Ensure project docs match your code changes.

2.  **Run Project Standard Verification**:
    - Follow the project's standard verification steps (pre-commit hooks, lint/test/build).
    - **IMPORTANT**: Run E2E tests locally and ensure they pass before creating a PR.

3.  **AI Quality Gate**:
    - Now you can safely finish. The system will check:
        1. Did the commit succeed?
        2. Is the documentation updated?

## 5. Push & PR

### 5.1 コンフリクトチェック（必須）

push前に必ずmainブランチとの差分を確認する:

```bash
git fetch origin
git merge-base --is-ancestor origin/main HEAD
```

- **成功（exit 0）**: mainの内容がHEADに含まれている → そのままpush可能
- **失敗（exit 1）**: mainが先に進んでいる → rebaseが必要

### 5.2 コンフリクト解消

上記チェックが失敗した場合、**`rebase-resolver` エージェントを呼び出す**:

```
rebase-resolver エージェントを使って、origin/main とのコンフリクトを解消してください。
```

エージェントが以下を実行:
1. `git rebase origin/main`
2. コンフリクト解消
3. 再生成（prisma generate等）
4. ローカル検証（lint/test/build）
5. `git push --force-with-lease`

### 5.3 PR作成

コンフリクトがない、または解消後にPRを作成:

```bash
git push origin HEAD
gh pr create --title "feat: Title" --body "Closes #<ISSUE_NUMBER>"
```

## 6. Post-PR Workflow (Quality Assurance Loop)

PR作成後、以下のプロセスを**全て問題なくなるまで繰り返す**。

### 6.1 並行タスク（サブエージェントに委譲）

以下の3つを**並行実行**する（各タスク最大15分）:

| タスク | 使用するスキル/エージェント | 内容 |
|:-------|:---------------------------|:-----|
| **Geminiレビュー** | `/subagent-review` → `review-checker` | 依頼送信 → 監視 → 指摘対応 |
| **CI監視** | `ci-debugger` エージェント | `gh pr checks --watch` → 失敗時は修正 |
| **Codexレビュー** | `review-checker` エージェント | 自動レビュー監視(10分以内) → 指摘対応 |

### 6.2 メインエージェント（並行で実行）

サブエージェント完了を待つ間、以下を実行:

- **整合性確認**: ドキュメント・テスト・実装の整合性をチェック
- **不整合修正**: 問題があれば修正

### 6.3 完了判定

以下のコマンドで各条件をチェック:

```bash
# CI チェック
gh pr checks --json name,state,conclusion | jq -e 'all(.conclusion == "success")'

# 未解決レビューコメント
gh api repos/{owner}/{repo}/pulls/{pr}/comments --jq '[.[] | select(.position != null)] | length' | grep -q '^0$'

# 未マージのレビュー要求
gh pr view --json reviewDecision --jq '.reviewDecision' | grep -qE '^(APPROVED|null)$'
```

### 6.4 ループ制御

```
1. 6.1 の並行タスクを実行
2. 各エージェントの Output を収集
3. 変更があれば:
   - git add -A && git commit && git push
   - → 1 に戻る（最大 5 回）
4. 完了判定:
   - CI 全通過 AND 未解決コメント 0 AND レビュー承認済み or 不要
   - → 完了
5. 5 回ループしても完了しない場合:
   - 現状をユーザーに報告して判断を仰ぐ

## 7. Session Retrospective

**全ての作業が完了したら**、セッションの振り返りを実行する。

`/session-retrospective` スキルを呼び出し、このセッションを分析する:

- 許可待ちの削減提案
- Memory / Rules の改善提案
- Skills / Agents の作成提案
- Hooks の追加提案

レポートは `.claude/retrospectives/` に保存される（リポジトリローカル）。
改善提案があれば、ユーザーに報告して次回以降の効率化につなげる。
