---
name: environment-setup
description: worktree作成後のプロジェクト初期化（依存関係/DB/環境変数）と次ステップのガイド
allowed-tools: Bash, Read, Grep, Glob
---

# 環境構築スキル（共通）

このスキルは worktree 作成後のプロジェクト初期化を担当する。
プロジェクト固有の設定は各リポジトリの `.claude/skills/environment-setup/SKILL.md` でオーバーライド可能。

## 1. プロジェクト検出

以下のファイルを確認してプロジェクトタイプを特定:

| ファイル | プロジェクトタイプ | パッケージマネージャ |
|----------|-------------------|---------------------|
| `package.json` + `pnpm-lock.yaml` | Node.js | pnpm |
| `package.json` + `yarn.lock` | Node.js | yarn |
| `package.json` + `package-lock.json` | Node.js | npm |
| `Cargo.toml` | Rust | cargo |
| `go.mod` | Go | go |
| `requirements.txt` / `pyproject.toml` | Python | pip/poetry |

## 2. 初期化手順

### 2.1 依存関係インストール

```bash
# Node.js
pnpm install  # or npm install / yarn install

# Rust
cargo build

# Go
go mod download

# Python
pip install -r requirements.txt  # or poetry install
```

### 2.2 環境変数ファイル

1. `.env.example` が存在すれば `.env` にコピー
2. `.env` の中身を確認し、必要に応じて値を設定

```bash
# .env が無ければ .env.example からコピー
[ ! -f .env ] && [ -f .env.example ] && cp .env.example .env
```

### 2.3 データベース初期化（必要な場合）

```bash
# PostgreSQL (Docker)
docker compose up -d db

# Prisma
npx prisma migrate dev

# Diesel
diesel migration run

# TypeORM
npm run typeorm migration:run
```

## 3. 構築後の次ステップ

環境構築完了後、以下を順番に確認:

### 3.1 開発サーバー起動確認

```bash
# Node.js
npm run dev  # または pnpm dev / yarn dev

# Rust
cargo run

# Go
go run .
```

### 3.2 ヘルスチェック

```bash
# APIが応答するか確認
curl -s http://localhost:3000/health || curl -s http://localhost:8080/health
```

### 3.3 テスト実行

```bash
# ユニットテストが通るか確認
npm test  # or pnpm test / cargo test / go test ./...
```

### 3.4 E2Eテスト準備（該当する場合）

```bash
# Playwright
npx playwright install  # ブラウザ初回インストール
npm run test:e2e        # E2Eテスト実行
```

### 3.5 次のアクション

環境構築が完了したら、`/fix` コマンドの次のフェーズ（Planning & Design）に進む。

## 4. トラブルシューティング

よくある問題と対処法:

### 4.1 ポート競合

**症状**: `EADDRINUSE` / `Address already in use`

**確認**:
```bash
lsof -i :3000  # または該当ポート
```

**対処**:
- 既存プロセスを終了: `kill -9 <PID>`
- または `.env` でポートを変更: `PORT=3001`

### 4.2 データベース接続失敗

**症状**: `ECONNREFUSED` / `Connection refused`

**確認**:
```bash
# PostgreSQL
pg_isready -h localhost -p 5432

# MySQL
mysql -h localhost -u root -e 'SELECT 1'

# Docker
docker compose ps
```

**対処**:
- Docker コンテナが起動しているか: `docker compose up -d`
- `.env` の `DATABASE_URL` が正しいか確認
- ホスト/ポート/認証情報を確認

### 4.3 スキーマ未適用

**症状**: `relation "xxx" does not exist` / `Table 'xxx' doesn't exist`

**確認**:
```bash
# Prisma
npx prisma migrate status

# Diesel
diesel migration list
```

**対処**:
```bash
# Prisma
npx prisma migrate dev

# Diesel
diesel migration run

# TypeORM
npm run typeorm migration:run
```

### 4.4 Playwright/E2E の BASE_URL 不一致

**症状**: E2Eテストがタイムアウト / 接続できない

**確認**:
- `.env` または `playwright.config.ts` の `baseURL` を確認
- 開発サーバーが起動しているか確認

**対処**:
```bash
# .env に正しいURLを設定
PLAYWRIGHT_BASE_URL=http://localhost:3000

# または開発サーバーを起動
npm run dev &
npm run test:e2e
```

## 5. Output

```markdown
## Environment Setup Result

### Status
[success/failed]

### Project Type
[Node.js (pnpm) / Rust / Go / Python / etc.]

### Completed Steps
- [x] Dependencies installed
- [x] .env configured
- [x] Database initialized (if applicable)

### Next Steps
1. 開発サーバー起動: `npm run dev`
2. ヘルスチェック: `curl localhost:3000/health`
3. テスト実行: `npm test`
4. 準備完了後、実装フェーズに進む

### Troubleshooting Reference
問題が発生した場合は「4. トラブルシューティング」を参照
```
