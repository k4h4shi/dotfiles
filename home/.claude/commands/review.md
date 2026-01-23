---
description: プロジェクトルールに沿ってPull Requestをレビューする。Usage: /review [PR_NUMBER]
---

# コードレビュー（共通コマンド）

このコマンドは共通インターフェース。可能ならプロジェクト固有のレビュールールを優先する。

## 1. PRを特定

PR番号が指定されていない場合は、現在のPR番号を探す:

```bash
gh pr view --json number -q .number
```

## 2. レビュー手順

プロジェクト固有のレビューガイダンスがあればそれに従う:

- **`review-guidelines` スキルがある場合**: それを使い、プロジェクトのルールセットに従う
- **無い場合**: `subagent-review` スキルでレビューを依頼する（**デフォルトは Codex**、Gemini も利用可能）

## 3. 報告

レビュー結果は `.tmp/review_body.md` にローカル保存される。

**PR への自動投稿は行わない**。必要に応じてユーザーが手動で投稿する:

```bash
# 投稿例
gh pr review <PR_NUMBER> --approve --body-file .tmp/review_body.md
gh pr review <PR_NUMBER> --request-changes --body-file .tmp/review_body.md
gh pr review <PR_NUMBER> --comment --body-file .tmp/review_body.md
```
