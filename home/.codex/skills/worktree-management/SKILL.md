---
name: worktree-management
description: "並行タスク用にgit worktreeを作成・管理する（worktreeが無い場合のみ）。Usage: /worktree-management"
---

# Worktree管理（共通）

このスキルは、対象タスクのworktreeが存在しない場合にのみ使用する。

## 手順

1) 事前確認（preflight）

- `git status --porcelain`
- 未コミットがある場合は commit/stash を行う
- `git fetch --all --prune`

2) ブランチとbaseを決める

- Branch: `feature/issue-<NUMBER>` or `fix/issue-<NUMBER>`
- Base: `origin/main`

3) ignore設定を確認

- `.worktrees/` が `.gitignore` にあることを確認

4) worktreeを作成

```bash
mkdir -p .worktrees
git worktree add .worktrees/<safe-branch-name> -b <branch> <base>
```

## 安全制約

- `rm -rf` で削除しない
- 削除は `git worktree remove` を使う（明示的に依頼がある場合のみ）

