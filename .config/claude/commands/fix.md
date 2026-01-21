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
