---
name: push-pr
description: Pushes the current branch and opens a Pull Request following project conventions. Use during /fix after pre-PR checks pass and you are ready to open a PR.
---

# Push & PR（共通）

このスキルは「作業結果を PR にする」ための **定型手順**を提供する。
プロジェクト固有の規約/SSOT は `AGENTS.md`（および最も近い scoped `AGENTS.md`）を正とする。

## 前提（必須）

- Pre-PR Check が通っている（lint/test/build/e2e の失敗がない）
- 作業ブランチ上にいる

## 事前決定（重要）: PR の base ブランチ

このスキルは **base ブランチを固定しない**。
必ず対象リポジトリの `AGENTS.md`（ルート）にある **ブランチ運用（PR）** を読み、PR の base を決める。

- 例: `develop` 集約のリポジトリ → base は `origin/develop`
- 例: `main` 集約のリポジトリ → base は `origin/main`

## チェックリスト（結果整合性の担保）

### 1) main 取り込み状況の確認
- PR の base ブランチ（例: `origin/develop` または `origin/main`）が取り込み済みか確認する
  - 例: `git fetch origin && git merge-base --is-ancestor <BASE> HEAD`
- 取り込み不足なら **自分で rebase** してコンフリクトを解消する（意図の判断が必要なため）
  - 例: `git rebase <BASE>`
- rebase 後は **Pre-PR Check に戻る**

### 2) push
- ブランチを push する（例: `git push -u origin HEAD`）

### 3) PR 作成
- `AGENTS.md` の PR 規約に従って、`gh pr create` で PR を作成する
- 必ず `Closes #<ISSUE_NUMBER>` を本文に含める

## 安全制約

- **禁止**: `develop` / `main` への直接 push（ブランチ保護前提）
- **許可**: topic ブランチの rebase 後の push は `--force-with-lease` を使う（必要な場合のみ）

## Output（メインへの報告用）

```markdown
## Push & PR Result

### Status
[created/failed]

### PR
<url>
```

