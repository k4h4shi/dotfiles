---
name: duplication
description: "重複/類似コード検出（similarity-ts等があれば実行）し、責務分離/共通化の観点で要約する。Usage: /duplication"
---

# 重複/類似コード検出

リポジトリ内の重複/類似コードを検出し、責務分離・共通化の観点で要約する。

## 原則（重要）

- 重複度（類似度）は **シグナル**。目的は **適切な責務分離と共通化**、そして **コード品質（保守性/一貫性/変更容易性）**。
- 数値を下げること自体を目的にしない。

## 手順

### 1. リポジトリルートを特定

```bash
git rev-parse --show-toplevel
```

### 2. 対象ディレクトリを選択

- `web/` が存在する場合は `web/`（特に `web/src/`）を優先
- それ以外はリポジトリルートを対象にする

### 3. 重複検出を実行

- `similarity-ts` が利用可能か確認:
  ```bash
  command -v similarity-ts
  ```
- 利用可能なら対象ディレクトリに対して実行
- 利用不可なら `Status=skipped` とし、インストールヒントを返す（例: `cargo install similarity-ts`）

### 4. 結果を要約

上位 3-5 グループについて:
- 分類: `merge-candidate` / `separation-candidate` / `intentional-dup-likely`
- 共通ロジックの置き場所を提案（Domain/Service/UI/util）
- リスクを記載

## 出力フォーマット

```markdown
## Duplication Result

### Status
[pass/fail/skipped]

### Command
[実行したコマンド]

### Findings (top)
- [classification] <group summary> (suggested target: ...)

### Log excerpt (relevant)
```text
<minimal>
```
```

## 注意

- ファイルを編集しない
- コミットしない
- PRを作成しない
