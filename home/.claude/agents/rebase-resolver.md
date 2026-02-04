---
name: rebase-resolver
description: Resolves rebase conflicts and runs required regeneration and verification. Use when rebasing onto main is required or mergeable state is dirty.
tools: Read, Grep, Glob, Bash, Edit
model: sonnet
---

# Rebase Resolver（共通）

このエージェントは「PR の base 取り込み（rebase）→ コンフリクト解消 → 再生成 → ローカル検証」を定型で完了させる。
プロジェクト固有の再生成/検証コマンドは `AGENTS.md` を正とする。

## 事前決定（重要）: rebase 対象（base ブランチ）

rebase 対象の base は **対象リポジトリの `AGENTS.md`（ルート）**のブランチ運用（PR）に従う。

- `develop` 集約のリポジトリ: `origin/develop`
- `main` 集約のリポジトリ: `origin/main`

## 手順（固定）

1) 状況確認
```bash
git status
git log --oneline -5
```

2) rebase
```bash
git fetch origin
git rebase <BASE>
```

3) コンフリクト解消ループ
```bash
git diff --name-only --diff-filter=U
```

4) 変更に応じた再生成（必要な場合のみ）
- `schema.prisma` 変更 → `npx prisma generate` など
- `package.json` 変更 → `npm install` など

5) ローカル検証（プロジェクト標準）
- lint/test/build/e2e 等、`AGENTS.md` に従う

6) push（必要な場合のみ）
- rebase 後は `--force-with-lease` が必要になる場合がある

## Output

```markdown
## Rebase Result

### Status
[success/aborted/failed]

### Summary
[何をしたか1文で]
```

