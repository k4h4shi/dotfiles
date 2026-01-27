---
description: "Implement a feature or fix a bug following TDD in a dedicated worktree. Usage: /fix [ISSUE_NUMBER]"
---

# Implement Issue (Common Command)

This command defines a **common interface**. Project-specific behavior is provided by skills or AGENTS.md.

## 前提（重要）

- あなたのための作業環境 は**Worktree で作成済み**
- 以降の作業は **必ず worktree 内**で行う（`pwd` で確認）
- プロジェクト固有の知識や指示は、 **各リポジトリの `AGENTS.md` と最も近い `AGENTS.md`** に従う

## チェックリスト

### 0) Setup（まず走らせる）
- [ ] `setup-checker` に委譲し、「要求される環境が整う」まで完了させる（メインは要約だけ受け取る）
- [ ] 可能ならバックグラウンドで走らせ、並行で 1) Understand / 2) Plan を進める

### 1) Understand
- [ ] `gh issue view <ISSUE_NUMBER>` で Issue を読む
- [ ] `AGENTS.md` を読み、プロジェクトの構造を把握する
- [ ] 一般的な技術調査（公式ドキュメント/公式Issue/Release等）が必要なら `official-researcher` に委譲し、要約だけ受け取る

### 2) Plan（複雑な場合のみ）
- [ ] 必要に応じて**プロジェクト固有の計画スキル**（例: `plan-guide`）に従って計画を作る
- [ ] （補助）長い作業は Tasks を使って分割・追跡し、SSOT はプロジェクト側（`AGENTS.md`/skills）に置く

### 3) Implement（TDD）
- [ ] 前提として、`setup-checker`が完了していることを確認する
- [ ] TDDの手順に従うことで、E2E, 結合, 単体のテストにより実装が十分にテストされた状態で開発を進める
- [ ] TDD の際のテスト実行に関しては **プロジェクト固有のテスト実行方法、スキル**（例:　`test-guide`）に従う
- [ ] build/type エラーは、まずプロジェクト固有の `build-fix` 等を優先する（ローカルのビルド/型エラー修正）

### 5) Docs（必須）
- [ ] docs更新は ** プロジェクト固有のドキュメント更新方針やスキル ** (例: `doc-update`)を使う
- [ ] ドキュメント、テスト、実装が整合していることを担保する

### 6) Pre-PR Check
- [ ] 検証は **並行で subagent に委譲**し、「要点＋抜粋ログ」だけ受け取り、メインで修正する
  - `linter-runner`（lint）
  - `tester-runner`（unit/integration）
  - `builder-runner`（typecheck/build）
  - `e2e-tester`（E2E）
- [ ] 失敗があれば、重要な失敗から順にメインで修正して再実行する
- [ ] `/subagent-review` スキルでレビューを行い、レビュー指摘に対応する

### 7) Push & PR
- [ ] Push〜PR作成は `push-pr` スキルで行う

### 8) Post-PR Check
- [ ] PR後の確認は **並行で subagent に委譲**し、「要点＋抜粋ログ」だけ受け取り、メインで修正する
  - `ci-debugger`（PR checks 監視 / 失敗ログの要点と抜粋）
  - `review-checker`（レビューコメント監視 / 要点と抜粋）
- [ ] 失敗/指摘があれば、重要なものから順にメインで修正して push する
- [ ] “CIが進まない” 場合は `mergeableState` を確認し、必要なら main 取り込み（rebase）を優先する

### 9) Session Retrospective

セッションの振り返りを実行する。

`/session-retrospective` スキルを呼び出し、このセッションを分析する:
レポートは `.claude/retrospectives/` に保存される（リポジトリローカル）。

### 10) Report
**全ての作業が完了したら** ユーザーに報告する。
