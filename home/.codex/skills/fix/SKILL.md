---
name: fix
description: "Issueの実装/修正をTDDで進める。Usage: /fix [ISSUE_NUMBER]"
---

# Implement Issue (Common)

このスキルは、Issue対応を **worktree + TDD** 前提で進めるための共通フローを提供する。

## 1. Preparation (Task Setup)

1. **要件確認**: Issue本文とプロジェクトのドキュメントを読む
2. **worktree 前提**:
   - Vive が worktree を作っている前提
   - 無い場合は `/worktree-management` を使って作成する
3. **ディレクトリ移動**:
   - 対象 worktree ディレクトリに移動する
   - 以降のコマンドは **必ず worktree 内で実行**する
4. **初期化（必要なら）**:
   - 新規 worktree: `environment-setup`（プロジェクト固有）を実行
   - 既存 worktree: `.env` と依存関係が揃っていればスキップ

### 1.1 環境構築後の確認（アイドリング防止）

`environment-setup` 完了後、**必ず以下を確認してから次に進む**:

| 確認項目 | コマンド例 | 問題時の対処 |
|----------|-----------|-------------|
| 開発サーバー起動 | `npm run dev` / `pnpm dev` | ログを確認、依存関係を再インストール |
| ポート競合 | `lsof -i :3000` | `kill -9 <PID>` または `.env` でポート変更 |
| DB接続 | `docker compose ps` / `pg_isready` | コンテナ起動、認証情報確認 |
| スキーマ適用 | `npx prisma migrate status` | `npx prisma migrate dev` |
| テスト実行 | `npm test` | エラーログを確認 |

## 2. Planning & Design

実装前に「計画が明確か？」を自問する。

- 複雑（複数レイヤー、複数ファイル大）なら `/planner` を使って実装計画を作る
- 設計判断が必要なら `/architect` を使って設計案とトレードオフを整理する

## 3. Implementation Flow (TDD)

TDDで進める。E2Eと単体がある場合は Nested TDD を優先する。

- 進行ガイド: `/tdd-runner`
- ビルド/型エラーが詰まる: `/build-error-resolver`

## 4. Final Verification & Documentation

実装が終わったら **必ず** 次を行う:

1. **ドキュメント整合**: `/doc-updater`（必要ならプロジェクトSSOTを更新）
2. **標準検証**: 変更に関係する `lint/test/build` をローカルで通す（E2Eがあるなら該当シナリオも）

## 5. Push & PR（必要なら）

### 5.1 コンフリクトチェック（必須）

```bash
git fetch origin
git merge-base --is-ancestor origin/main HEAD
```

- exit 0: そのまま push 可能
- exit 1: main が先に進んでいる → `/rebase-resolver`

### 5.2 PR作成

PR作成が必要なら `/pr-creator` を使う。

