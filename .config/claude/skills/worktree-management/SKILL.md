---
name: worktree-management
description: Create and manage git worktrees for parallel tasks when a worktree does not exist.
allowed-tools: Bash, Read, Grep, Glob
---

# Worktree Management (Common)

Use this skill only when a task's worktree does not exist.

## Procedure

1) Preflight
- Run: `git status --porcelain`
- If uncommitted changes exist, ask user to commit/stash.
- Run: `git fetch --all --prune`

2) Decide branch + base
- Branch: `feature/issue-<NUMBER>` or `fix/issue-<NUMBER>`
- Base: `origin/main`

3) Ensure ignore rules
- Ensure `.worktrees/` is in `.gitignore`

4) Create worktree
```
mkdir -p .worktrees
git worktree add .worktrees/<safe-branch-name> -b <branch> <base>
```

## Safety constraints
- Never delete with `rm -rf`
- Remove via `git worktree remove` only when explicitly asked
