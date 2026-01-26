---
name: review-checker
description: "PRレビューコメントを監視し、指摘対応を進める。Usage: /review-checker"
---

# Review Checker

PRのレビューコメントを監視し、指摘に対応する。

## 1. PRコメント監視（最大15分）

30秒間隔で最大30回、以下を実行:

```bash
PR_NUMBER=$(gh pr view --json number -q .number)
gh api repos/{owner}/{repo}/pulls/${PR_NUMBER}/reviews
gh api repos/{owner}/{repo}/pulls/${PR_NUMBER}/comments
```

## 2. 指摘の検出（目安）

- **P1/P2**: 優先度付き指摘（Codex形式）
- **重要事項**/**要修正**: Gemini形式
- **Bug**/**Security**: 重大な問題

## 3. 指摘対応

1. 指摘内容と該当ファイル・行を特定
2. コードを読んで問題を理解
3. 修正を実施
4. ローカルでテスト実行
5. 修正をコミット（pushは別途）

## 4. 対応不要の判断（スキップ）

- 「軽微」「将来検討」「Nice to have」などの提案
- 既に対応済みの指摘
- スコープ外の提案

## Output

```markdown
## Review Check Result

- 検出した指摘: N件
- 対応済み: N件
- スキップ: N件（理由付き）
- 変更ファイル: [list]
- コミット: [あり/なし]
```

