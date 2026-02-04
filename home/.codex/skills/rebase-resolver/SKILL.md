---
name: rebase-resolver
description: "rebaseコンフリクトを定型手順で解消する。Usage: /rebase-resolver"
---

# Rebase Resolver

rebase時のコンフリクト解決を支援する。

## 0. 事前決定（重要）: rebase 対象（base ブランチ）

rebase 対象の base は **対象リポジトリの `AGENTS.md`（ルート）**のブランチ運用（PR）に従う。

- `develop` 集約のリポジトリ: `origin/develop`
- `main` 集約のリポジトリ: `origin/main`

## 1. 状況確認

```bash
git status
git log --oneline -5
git log --oneline <BASE>..HEAD
```

## 2. Rebase開始

```bash
git fetch origin
git rebase <BASE>
```

## 3. コンフリクト解消ループ

```bash
# コンフリクトファイルを確認
git diff --name-only --diff-filter=U

# 各ファイルを確認・修正（<<<<<<<, =======, >>>>>>> を解消）
```

解消後:

```bash
git add <resolved-files>
git rebase --continue
```

## 4. 再生成チェック（よくある落とし穴）

| 条件 | コマンド |
|:-----|:---------|
| `prisma/schema.prisma` が変更された | `npx prisma generate` |
| `package.json` が変更された | `npm install` または `pnpm install` |
| `Cargo.toml` が変更された | `cargo build` |
| `go.mod` が変更された | `go mod tidy` |
| `flake.nix` が変更された | `nix develop` で再入場 |
| GraphQL schema が変更された | codegen を実行 |
| OpenAPI spec が変更された | クライアント再生成 |

```bash
git diff --name-only <BASE>...HEAD
```

## 5. ローカル検証

```bash
# lint
npm run lint 2>/dev/null || pnpm lint 2>/dev/null || cargo clippy 2>/dev/null || true

# type check
npm run typecheck 2>/dev/null || npx tsc --noEmit 2>/dev/null || true

# test
npm test 2>/dev/null || pnpm test 2>/dev/null || cargo test 2>/dev/null || true

# build
npm run build 2>/dev/null || pnpm build 2>/dev/null || cargo build 2>/dev/null || true
```

## 6. Push（rebase後）

```bash
git push --force-with-lease origin HEAD
```

## 中断時の対処

```bash
git rebase --abort
```

## Output

```markdown
## Rebase Result

### Status
[success/aborted/failed]

### Summary
[何をしたか1文で]

### Resolved Conflicts
- [file1]: [解消方法の概要]

### Regenerated
- [実行した再生成コマンド]

### Verification
- Lint: [pass/fail/skipped]
- TypeCheck: [pass/fail/skipped]
- Test: [pass/fail/skipped]
- Build: [pass/fail/skipped]

### Push
[pushed/not-pushed/failed]
```

