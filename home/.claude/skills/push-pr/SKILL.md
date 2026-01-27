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

## チェックリスト（結果整合性の担保）

### 1) main 取り込み状況の確認
- `origin/main` が取り込み済みか確認する
  - 例: `git fetch origin && git merge-base --is-ancestor origin/main HEAD`
- 取り込み不足なら **自分で rebase** してコンフリクトを解消する（意図の判断が必要なため）
- rebase 後は **Pre-PR Check に戻る**

### 2) push
- ブランチを push する（例: `git push -u origin HEAD`）

### 3) PR 作成
- `AGENTS.md` の PR 規約に従って、`gh pr create` で PR を作成する
- 必ず `Closes #<ISSUE_NUMBER>` を本文に含める

## Output（メインへの報告用）

```markdown
## Push & PR Result

### Status
[created/failed]

### PR
<url>
```

