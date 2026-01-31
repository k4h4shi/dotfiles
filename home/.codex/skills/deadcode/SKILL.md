---
name: deadcode
description: "デッドコード（未使用コード）を検出し、削除候補を優先度付けで要約する。Usage: /deadcode"
---

# デッドコード検出

リポジトリ内のデッドコード（未使用のエクスポート、ファイル、依存関係）を検出し、削除候補を要約する。

## 原則（重要）

- デッドコード検出は **シグナル**。目的は **不要コードの特定と安全な削除**、そして **コード品質（可読性/保守性/ビルド時間短縮）**。
- 検出されたコードを機械的に削除しない。以下を確認する:
  - 意図的に残しているコード（将来利用予定、フラグ切替等）
  - テストでのみ使用されるコード
  - 動的インポート/リフレクションで使用されるコード

## 手順

### 1. リポジトリルートを特定

```bash
git rev-parse --show-toplevel
```

### 2. 対象ディレクトリとツールを選択

#### TypeScript/JavaScript プロジェクト

優先順位:
1. `knip` が利用可能か確認（推奨）:
   ```bash
   command -v knip || npx knip --help 2>/dev/null
   ```
2. `ts-prune` が利用可能か確認:
   ```bash
   command -v ts-prune
   ```
3. `unimported` が利用可能か確認:
   ```bash
   command -v unimported || npx unimported --help 2>/dev/null
   ```

#### Rust プロジェクト

- `cargo-udeps` が利用可能か確認:
  ```bash
  cargo udeps --help 2>/dev/null
  ```
- なければ `cargo build` の警告から `dead_code` lint を収集

### 3. デッドコード検出を実行

#### knip（TypeScript/JavaScript推奨）

```bash
# web/ が存在する場合
cd web && npx knip --reporter compact

# リポジトリルートの場合
npx knip --reporter compact
```

#### ts-prune

```bash
cd web && npx ts-prune
```

#### unimported

```bash
cd web && npx unimported
```

#### Rust

```bash
cargo +nightly udeps --all-targets 2>&1 || \
  cargo build 2>&1 | grep -E "(warning.*dead_code|warning.*unused)"
```

ツールが利用不可の場合は `Status=skipped` とし、インストールヒントを返す（例: `npm install -D knip`, `cargo install cargo-udeps`）

### 4. 結果を要約

上位 5-10 件について:

- **分類**: 
  - `safe-to-remove`: 明らかに不要（テストでも使われていない）
  - `verify-first`: テストまたは動的ロードで使用の可能性あり
  - `intentional-likely`: 意図的に残している可能性が高い（TODO/FIXME付き、feature flag関連等）
- **種別**: `unused-export` / `unused-file` / `unused-dependency` / `dead-function`
- **削除時の影響範囲**を記載

## 出力フォーマット

```markdown
## Deadcode Result

### Status
[pass/fail/skipped]

### Tool
[使用したツール名とバージョン]

### Command
[実行したコマンド]

### Findings (top)
| Priority | Type | Location | Classification | Note |
|----------|------|----------|----------------|------|
| 1 | unused-export | src/utils/old.ts:fn | safe-to-remove | 参照なし |
| 2 | unused-file | src/legacy/helper.ts | verify-first | テストから参照の可能性 |
| ... | ... | ... | ... | ... |

### Summary
- Total unused exports: N
- Total unused files: N
- Total unused dependencies: N

### Recommendations
- [削除優先度の高いものから順に推奨アクション]

### Log excerpt (relevant)
```text
<minimal>
```
```

## 注意

- ファイルを編集しない
- コミットしない
- PRを作成しない
- 削除は別タスクとしてユーザーが判断する
