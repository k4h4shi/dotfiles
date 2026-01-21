---
description: Create or manage GitHub issues. Usage: /issue [ISSUE_NUMBER]
---

# Manage Issues (Common Command)

## 1. View Issue

To view details of an issue:

```bash
gh issue view <ISSUE_NUMBER>
```

## 2. Create Issue

1.  **Draft Content**: Create a temporary file with the issue description.

    ```markdown
    ## Summary
    What needs to be done.

    ## Context
    Why it is needed.

    ## Acceptance Criteria
    - [ ] Criterion 1
    ```

2.  **Create**:

    ```bash
    gh issue create --title "Title" --body-file <PATH_TO_FILE>
    ```

## 3. List Issues

```bash
gh issue list
```
