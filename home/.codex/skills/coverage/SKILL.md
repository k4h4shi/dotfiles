---
name: coverage
description: "コードカバレッジを実行し、結果を「不足テスト観点」に翻訳して返す。数値追跡ではなくテストカバレッジ/有効性に寄せる。Usage: /coverage"
---

# コードカバレッジ分析

リポジトリのカバレッジを実行し、結果を「不足テスト観点」として要約する。

## 原則（重要）

- コードカバレッジは **シグナル**。目的は **不足テスト観点の発見**（テストカバレッジ/テスト有効性の向上）。
- 数字を上げること自体を目的にしない。

参考: [コードカバレッジ vs. テストカバレッジ vs. テスト有効性](https://www.qt.io/ja-jp/blog/code-coverage-vs.-test-coverage-vs.-test-effectiveness-what-do-you-measure)

## 手順

### 1. リポジトリルートを特定

```bash
git rev-parse --show-toplevel
```

### 2. カバレッジコマンドを特定

優先順位:
1. `AGENTS.md` や `docs/` に記載されたコマンドを優先
2. `web/package.json` に `test:coverage` スクリプトがあれば: `cd web && npm run test:coverage`
3. `package.json` に `test:coverage` または `coverage` があれば実行
4. どれもなければ `Status=skipped` とし、何を探したか説明する

### 3. lcov ファイルを探す

```bash
# 例
coverage/lcov.info
web/coverage/lcov.info
```

### 4. 結果を要約

低カバレッジ領域について（上位 3-5 件）:
- ファイルと未カバー行範囲をエビデンス（シグナル）として使用
- 各ファイルについて 1-2 個のテストアイデアを提案
- 観点: エラーハンドリング、分岐、境界値、認証/権限、状態遷移/並行性、SSOTシナリオ

## 出力フォーマット

```markdown
## Coverage Result

### Status
[pass/fail/skipped]

### Command
[実行したコマンド]

### Artifact
- lcov: <path or none>

### Low coverage -> test ideas (top)
- <file>: lines <ranges> -> <missing test idea>

### Log excerpt (if failed)
```text
<minimal>
```
```

## 注意

- ファイルを編集しない
- コミットしない
- PRを作成しない
