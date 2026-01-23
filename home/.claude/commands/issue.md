---
description: GitHub Issueを作成・確認する。Usage: /issue [ISSUE_NUMBER]
---

# Issue管理（共通コマンド）

## 1. Issueを確認

Issueの詳細を確認する:

```bash
gh issue view <ISSUE_NUMBER>
```

## 2. Issueを作成

1.  **下書き作成**: Issue本文を一時ファイルに書く

    ```markdown
    ## 概要
    何をやるか。

    ## 背景
    なぜ必要か。

    ## 完了条件
    - [ ] 条件1
    ```

2.  **作成**:

    ```bash
    gh issue create --title "Title" --body-file <PATH_TO_FILE>
    ```

## 3. Issue一覧

```bash
gh issue list
```
