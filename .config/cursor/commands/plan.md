---
description: Fetch all issues, prioritize them, and identify the critical path. Usage: /plan
---

# Plan & Prioritize Tasks

Use this command to analyze the current project state, prioritize open issues, and determine the critical path for development.

## 1. Fetch Issues

First, fetch all open issues from GitHub to understand the current workload.

```bash
gh issue list --limit 100 --state open --json number,title,labels,updatedAt,assignees
```

## 2. Analyze & Prioritize

Based on the fetched issues and the project goals (refer to `docs/` if needed), analyze the tasks.

### Output Format

Output the analysis in the following markdown format:

```markdown
# Project Plan Analysis

## 1. Parallel Execution Map

依存関係を分析し、並行実装可能なタスクを Mermaid 図で示す。

\`\`\`mermaid
graph LR
    subgraph "Phase 1 (並行実装可能)"
        A["#101 Feature A"]
        B["#102 Feature B"]
        C["#103 Refactor C"]
    end

    subgraph "Phase 2 (Phase 1 完了後)"
        D["#104 Integration"]
    end

    subgraph "Phase 3"
        E["#105 E2E Tests"]
    end

    A --> D
    B --> D
    C --> D
    D --> E
\`\`\`

**並行実装の判断基準**:
- 同一ファイルを編集しない
- 依存する機能がない
- 独立してテスト可能

## 2. Critical Path
- **Goal**: [Current Milestone/Goal]
- **Blocking**: [List of blocking issues]
- **Path**: [Issue A] -> [Issue B] -> [Goal]

## 3. Priority List
| Priority | Issue | Title | Parallel Group | Reasoning |
| :--- | :--- | :--- | :--- | :--- |
| P0 | #123 | Title | Phase 1 | [Reason for high priority] |
| P0 | #124 | Title | Phase 1 | [Can run in parallel with #123] |
| P1 | #125 | Title | Phase 2 | [Depends on #123, #124] |

## 4. Recommendations
- **Parallel Tasks**: [List issues that can be implemented in parallel using worktrees]
- **Next Action**: [What to do next]
- **Missing Tasks**: [Any necessary tasks not yet tracked as issues]
```

## 3. Action

Ask the user if they want to:
1. Create new issues for missing tasks (using `gh issue create`).
2. Start working on the highest priority issue (using `/fix <issue_number>`).
