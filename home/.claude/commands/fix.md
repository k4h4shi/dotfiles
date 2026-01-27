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
- **Testing Policy（原則）**: 変更に対応するテストを **単体テスト / 結合（Integration）テスト / E2E** のレイヤーで適切に追加・更新し、網羅性を上げる。
  - 基本はTDD（Red/Green/Refactor）で充足するはずだが、実装のステップごとに「この変更はどのレイヤーのテストで担保するのが最適か」を見直し、必要なら追加する（例: ユニットだけでは不安→結合/E2Eを足す）。
  - 例外（docsのみ/純粋リファクタ/自動テストで再現困難 等）は限定し、**追加しない理由をPRに明記**する。
  - フリーキーなテストは、発見した担当の責務として **必ず直す**（放置しない）。
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
    - **IMPORTANT**: PR作成前に、変更に関係するテスト（単体/結合/E2E）をローカルで実行してパスを担保する。
      - 特に E2E があるプロジェクトでは、当該変更に関係して追加した主要シナリオ＋リグレッションがパスしていること。

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
5. `git push --force-with-lease`（**必要な場合のみ**。安全のため、実行前に「force push が必要な理由」と「対象が作業ブランチ（mainではない）であること」を明記してユーザーに確認する）

### 5.3 PR作成

コンフリクトがない、または解消後にPRを作成:

```bash
git push origin HEAD
gh pr create --title "feat: Title" --body "Closes #<ISSUE_NUMBER>"
```

## 6. Post-PR Workflow（別スキルへ）

PR作成後のQA（CI監視/レビュー監視/指摘対応）は、`/fix` を肥大化させてコンテキストを圧迫しやすいので **別スキルで実行**する:

- `/post-pr-workflow`

## 7. Session Retrospective

**全ての作業が完了したら**、セッションの振り返りを実行する。

`/session-retrospective` スキルを呼び出し、このセッションを分析する:

- 許可待ちの削減提案
- Memory / Rules の改善提案
- Skills / Agents の作成提案
- Hooks の追加提案

レポートは `.claude/retrospectives/` に保存される（リポジトリローカル）。
改善提案があれば、ユーザーに報告して次回以降の効率化につなげる。
