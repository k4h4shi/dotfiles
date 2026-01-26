---
name: tdd-runner
description: "TDD（Nested TDD含む）の進行ガイド。Usage: /tdd-runner"
---

# TDD Runner

Kent Beck / t-wada の TDD に従い実装を進めるための共通フロー。

## Step 0: プロジェクト情報の収集

実装前に、プロジェクト固有の情報を収集する:

- `AGENTS.md` / `CODEX.md` / `CLAUDE.md` / `README.md` / `package.json` / `Makefile` などから実行コマンド・規約を確認
- 既存テストからテストの粒度・配置規則・モック方針を把握

## Step 1: テストリストを作る

TODOリスト形式で、実装すべき振る舞いを列挙する:

```markdown
## Test List
- [ ] 振る舞い1
- [ ] 振る舞い2
- [ ] 振る舞い3
```

## Step 2: Nested TDD（E2E + 単体テストがある場合）

プロジェクトに E2E テストと単体テストの両方が存在する場合、Nested TDD を行う:

```
外側ループ: ユースケースレベル（E2E / 受け入れテスト）
  │
  ├─ Red: E2Eテストを書く → 失敗
  │
  ├─ 内側ループ: 単体テストレベル
  │    ├─ Red: 単体テストを書く → 失敗
  │    ├─ Green: 最小限の実装
  │    ├─ Refactor
  │    └─ 繰り返し
  │
  ├─ Green: E2Eテストが通る
  │
  └─ Refactor
```

1. 外側の Red: ユースケースを満たす E2E テストを書き、失敗を確認
2. 内側の TDD サイクル: E2E を通すために必要な単体テストを TDD で実装
3. 外側の Green: 内側が完了すると E2E テストが通る
4. 外側の Refactor: 全体を整理

## Step 3: 基本の TDD サイクル（単体テストのみの場合）

E2E がない、または単体テストのみで十分な場合は基本のサイクルを回す:

1. Red: テストを書き、失敗を確認
2. Green: テストを通す最小限の実装
3. Refactor: テストが通る状態を維持しつつ整理

## エラー時の対応

- ビルド/型エラー: 3回試行 → 失敗なら `/build-error-resolver`
- テスト失敗が続く: 5回試行 → いったん計画を見直す（必要なら `/planner`）
- 設計の問題: 保留して `/architect` で整理し直す

## Output

```markdown
## TDD Result

### Summary
- テストリスト: N件
- 完了: N件
- 保留: N件

### Completed Tests
1. [テスト名]: [実装内容の1行要約]

### Issues (if any)
- [問題があれば記載]

### Files Changed
- path/to/file
```

