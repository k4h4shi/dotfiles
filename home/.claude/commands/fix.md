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
以下の"{n}) ステップ: 完了条件"に基づくリストを満たしなさい。
必要に応じてユーザーに指示を仰ぎつつも、全てのチェックを満たすまで自律的に実行しなさい。

### 0) Setup: タスクを行う上での前提となる環境が整うこと
- [ ] `setup-checker` に委譲し、「要求される環境が整う」まで完了させる
- [ ] 可能ならバックグラウンドで走らせ、並行で 1) Understand / 2) Plan を進める

### 1) Understand: タスクの前提条件を理解すること
- [ ] `gh issue view <ISSUE_NUMBER>` で Issue を読む
- [ ] `AGENTS.md` を読み、プロジェクトの構造を把握する
- [ ] 一般的な技術調査（公式ドキュメント/公式Issue/Release等）が必要なら `official-researcher` に委譲し、結果を受け取る

### 2) Plan（複雑な場合のみ）: 作業計画が立ち、完了までの道筋を把握すること
- [ ] 必要に応じて**プロジェクト固有の計画スキル**（例: `plan-guide`）に従って計画を作ります

### 3) Implement（TDD）: 要件および仕様を満たし、テストで担保された実装が追加されること
- [ ] 前提として、`setup-checker`が完了していることを確認する
- [ ] TDDの手順に従うことで、E2E, 結合, 単体のテストにより実装が十分にテストされた状態を維持しながら開発を進める
- [ ] TDD の際のテスト実行に関しては **プロジェクト固有のテスト実行方法、スキル**（例:　`test-guide`）に従う

### 4) Docs（必須）: ドキュメンテーション、テスト、実装の一致が保証されること
- [ ] docs更新は ** プロジェクト固有のドキュメント更新方針やスキル ** (例: `doc-update`)を使う
- [ ] ドキュメント、テスト、実装が整合していることを担保する

### 5) Pre-PR Check: PR作成前に動作確認と品質確認が完了すること
- [ ] 検証は **並行で subagent に委譲**し、「要点＋抜粋ログ」だけ受け取り、メインで修正する
  - `linter-runner`（lint）
  - `tester-runner`（unit/integration）
  - `builder-runner`（typecheck/build）
  - `e2e-tester`（E2E）
  - `/subagent-coverage`（coverage→不足テスト観点の翻訳）
  - `/subagent-duplication`（重複/類似コード→責務分離/共通化の候補）
  - `/subagent-review local`（lint等と並行でローカル差分レビュー）
- [ ] 失敗や指摘があり次第、修正して再度Pre-PR Checkする

### 6) Push & PR: PRが作成されること
- [ ] Push〜PR作成は `push-pr` スキルで行う

### 7) Post-PR Check: PRがマージ可能な状態になること
- [ ] PR後の確認は **並行で subagent に委譲**し、「要点＋抜粋ログ」だけ受け取り、メインで修正する
  - `ci-checker`（PR checks 監視 / 失敗ログの要点と抜粋）
  - `review-checker`（レビューコメント監視 / 要点と抜粋）
- [ ] 失敗や指摘があり次第、修正してコミット&プッシュ後、再度Post-PR Checkをする
- [ ] “CIが進まない” 場合は `mergeableState` を確認し、必要なら main 取り込み（rebase）を優先する

### 8) Session Retrospective: セッションのレポートが作成され、配置されること

セッションの振り返りを実行する。

`/session-retrospective` スキルを呼び出し、このセッションを分析する:
レポートは `.claude/retrospectives/` に保存される（リポジトリローカル）。

### 9) Report: サマリーがユーザーに報告されること
**全ての作業が完了したら** ユーザーに報告する。
