---
description: プロジェクトのガイドラインに沿ってPRをレビューする。Usage: /review [PR_NUMBER]
---

# コードレビュー（静的解析）

Git Worktree を使用した独立環境で、プルリクエストの静的コードレビューを実行します。
**このコマンドの実行中に、ワークツリーの削除やコードの変更は絶対に行わないでください。**

## 使用例

- `/review #123` - PR #123 のコードをレビュー

## 手順

### 1. ワークツリーのセットアップ

1.  **PR 情報の取得**:

    ```bash
    gh pr view <PR番号> --json headRefName,baseRefName
    ```

2.  **既存ワークツリーの確認**:

    - `git worktree list` を実行し、`headRefName` のワークツリーが既に存在しないか確認します。
    - **存在する場合**: 既存のワークツリーを利用してレビューを続行します。
    - **存在しない場合**: 次のステップに進み、新しいワークツリーを作成します。

3.  **ワークツリーの作成（必要な場合のみ）**:

    - `worktree-manager` エージェントを使用します。
    - **Branch**: 上記で取得した `headRefName` を指定。
    - **Base**: `baseRefName` (通常は `origin/main`)。
    - **注意**: 静的レビューのみのため、環境初期化は基本スキップ（必要なら `environment-setup` スキル）。

4.  **コンテキスト切り替え**:

    ```bash
    cd .worktrees/<branch-name>
    ```

### 2. レビュー実施

プロジェクトのガイドラインに基づきコードを分析します。

- まず `AGENTS.md` / `docs/` / `.cursor/rules/` を参照
- `review-guidelines` スキルがある場合は必ず使用

#### 分析コマンド

```bash
# 変更ファイル一覧の取得
git diff --name-only origin/main...HEAD
```

### 3. レビュー報告

GitHub PR にコメントを投稿します。

1.  **レビュー内容をファイルに書き出す**:

    ```bash
    # `write_file` ツールを使用
    # content: レビュー内容のマークダウン
    # file_path: ./.tmp/review_body.md
    ```

2.  **PR にコメントを投稿**:

    ```bash
    gh pr review <PR番号> --comment --body-file ./.tmp/review_body.md
    ```

**レビューコメントは日本語で記述してください。**
