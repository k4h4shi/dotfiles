---
name: pr-creator
description: "定型フォーマットでPull Requestを作成する（日本語タイトル）。Usage: /pr-creator"
---

# PR 作成（共通）

イシュー番号を **先頭**にして、**タイプは付けない**日本語タイトルで PR を作成する。

## 手順

1. **文脈を把握**
   - 現在のブランチ名を取得: `git branch --show-current`
   - ブランチ名から Issue 番号を抽出
     - 例: `feature/issue-123` -> `123`, `fix/456-bug` -> `456`
2. **PR タイトル決定（日本語・タイプなし）**
   - フォーマット: `[#IssueNum] <日本語タイトル>`
   - 可能なら Issue タイトルを取得:  
     `gh issue view {IssueNum} --json title --jq .title`
3. **PR 本文を準備**
   - `Closes #{IssueNum}` を必ず含める
   - `Summary` と `Test Plan` を含める
4. **PR を作成**
   - 必要なら push: `git push -u origin HEAD`
   - `gh pr create` で作成

```bash
gh pr create --title "[#{IssueNum}] {Title}" --body "$(cat <<'EOF'
Closes #{IssueNum}

## Summary
{Summary}

## Test Plan
- [ ] {Test Step 1}
- [ ] {Test Step 2}
EOF
)"
```

## Output

```markdown
## PR Creation Result

### Status
[created/failed]

### Summary
[何をしたか1文で]

### PR URL
https://github.com/owner/repo/pull/N

### Issue
Closes #N
```

