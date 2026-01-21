---
description: Implement a feature or fix a bug following TDD in a dedicated worktree. Usage: /fix [ISSUE_NUMBER]
---

# Implement Issue (Common Command)

This command defines a **common interface**. Project-specific behavior is provided by skills with the same names.

## 1. Preparation (Task Setup)

1.  **Understand the Requirement**: Read the issue and the project's docs.
2.  **Worktree is created by Vive** for the task.
    - If it does not exist, refer to the `worktree-management` skill and create it.
3.  **Project Initialization** (if needed):
    - Use the `environment-setup` skill for project-specific setup (deps/DB/env).

4.  **Switch Context**:
    - Change directory to the task's worktree.
    - **IMPORTANT**: All subsequent commands must be run INSIDE this worktree directory.

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

3.  **AI Quality Gate**:
    - Now you can safely finish. The system will check:
        1. Did the commit succeed?
        2. Is the documentation updated?

## 5. Push & PR

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

### 6.3 ループ判定

```
if (変更あり) {
    git add -A && git commit && git push
    → 6.1 に戻る
} else if (全サブエージェント成功 && CI通過 && レビュー指摘なし) {
    → 完了報告してユーザーに通知
} else {
    → 6.1 に戻る
}
```

### 6.4 完了条件

以下が全て満たされた時点で完了:

- [ ] CI全チェック通過
- [ ] Geminiレビュー指摘対応完了
- [ ] Codexレビュー指摘対応完了
- [ ] ドキュメント・テスト・実装の整合性確認完了

## 7. Session Retrospective

**全ての作業が完了したら**、セッションの振り返りを実行する。

`/subagent-retrospective` スキルを呼び出し、Gemini にこのセッションを分析させる:

- 許可待ちの削減提案
- Memory / Rules の改善提案
- Skills / Agents の作成提案
- Hooks の追加提案

改善提案があれば、ユーザーに報告して次回以降の効率化につなげる。
