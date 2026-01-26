---
name: doc-updater
description: "仕様/ドキュメントの整合を更新する。Usage: /doc-updater"
---

# Documentation Updater

変更に合わせてドキュメントを更新し、矛盾をなくすための共通フロー。

## Instructions

1. 変更によって影響を受けるドキュメントを特定する
2. 現在の挙動に合わせてドキュメントを更新する
3. ドキュメント間の矛盾がないことを確認する

## Checklist

- 仕様と実装が一致しているか
- 関連ドキュメント間で矛盾がないか
- 変更点が第三者に伝わるか

## Output

```markdown
## Documentation Update Result

### Status
[success/no_changes_needed]

### Summary
[何を更新したか1-2文で]

### Updated Files
- path/to/doc

### Verification
- [ ] 仕様と実装が一致
- [ ] ドキュメント間の矛盾なし
```

