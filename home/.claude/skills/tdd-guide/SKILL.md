---
name: tdd-guide
description: Provides a step-by-step TDD workflow (Red-Green-Refactor, including Nested TDD). Use when implementing with TDD or when the user mentions t-wada, Kent Beck, or nested TDD.
---

# TDD Guide（共通 / Nested TDD）

このスキルは **TDDの「手順の型」**だけを提供する（知識講義はしない）。
プロジェクト固有のテスト配置/実行コマンド/SSOT は `AGENTS.md`（および最も近い scoped `AGENTS.md`）を正とする。

## いつ使うか

- ユーザーが「TDDで進めて」「t-wada」「Kent Beck」「Nested TDD」「Red Green Refactor」と言及したとき
- 実装を「テストで狙い撃ち」しながら反復したいとき

## 最初にやること（必須）

- [ ] `AGENTS.md` を読む（SSOT/テストの場所/標準コマンド）
- [ ] 「外側（E2E/受け入れ）」が必要か判断する
  - UI/画面/ユースケースが変わる → 外側ループ（Nested）を使う
  - 純粋ロジック/小変更 → 内側ループのみでよい

## チェックリスト（進行用テンプレ）

```markdown
TDD Progress:
- [ ] Test list を作る（外側/内側）
- [ ] Red（失敗を確認）
- [ ] Green（最小実装で通す）
- [ ] Refactor（振る舞いを保ったまま整理）
- [ ] Verification（プロジェクト標準の lint/test/build/e2e）
```

## 内側ループ（基本: Red → Green → Refactor）

1) **Red**
- [ ] 1つの振る舞いだけをテストで固定する（入力→出力 or 状態→結果）
- [ ] そのテストが **失敗する**ことを確認する

2) **Green**
- [ ] 最小差分でテストを通す（設計はまだ最小でよい）
- [ ] テストが **確実に通る**ところまで反復する

3) **Refactor**
- [ ] 重複排除、命名改善、責務分割を行う（振る舞いは変えない）
- [ ] テストが通ることを維持する

## 外側ループ（Nested TDD: 受け入れ/E2E → 内側TDD）

外側ループは「ユースケースが満たされること」を固定するために使う。

1) **外側 Red（受け入れ/E2E）**
- [ ] SSOT（ユースケース/画面仕様）に沿って、シナリオをテストとして書く
- [ ] 失敗することを確認する

2) **内側ループ（単体/結合）**
- [ ] 外側テストを通すために必要な “小さい振る舞い” をテストで分解する
- [ ] それぞれ Red→Green→Refactor を回す

3) **外側 Green**
- [ ] 外側テストが通ることを確認する

4) **外側 Refactor**
- [ ] 全体の構造を整理（テスト資産/ヘルパー/責務の境界）

## 出力（セッション内の要約）

作業の途中/最後に、以下の形で要約する。

```markdown
## TDD Result

### Test list
- [ ] ...

### What changed
- ...

### Verification
- local: [what ran / pass-fail]
```

