---
name: build-error-resolver
description: "ビルド/型エラーを最小差分で修正する。Usage: /build-error-resolver"
---

# Build Error Resolver

共通のビルド/型エラー修正フローを提供する。

## Workflow

1. **Collect Errors**
   - 失敗したコマンドとエラー出力を収集
2. **Classify**
   - 型エラー / 依存関係 / 設定 / ビルドのどれかを判定
3. **Minimal Fix**
   - 最小差分で原因を修正（リファクタはしない）
4. **Verify**
   - 同じコマンドを再実行して確認

## Principles

- 変更範囲は最小
- アーキテクチャの改変は禁止
- 1回の修正で1原因に集中する

## Output

```markdown
## Build Error Result

### Status
[success/failed]

### Summary
[何を修正したか1-2文で]

### Error Type
[型エラー/依存関係/設定/ビルド]

### Changes
- path/to/file

### Verification
[再実行結果: pass/fail]
```

