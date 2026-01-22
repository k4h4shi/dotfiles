---
description: Review a Pull Request using project rules. Usage: /review [PR_NUMBER]
---

# Code Review (Common Command)

This command is a common interface. Prefer project-specific review rules when available.

## 1. Identify the PR

If a PR number is not provided, find it:

```bash
gh pr view --json number -q .number
```

## 2. Review Process

Use the project-specific review guidance if it exists:

- **If `review-guidelines` skill exists**: use it and follow the project's rule set.
- **Otherwise**: use the `subagent-review` skill to request a Gemini review.

## 3. Reporting

Post your review comments to the PR following the project's conventions.
