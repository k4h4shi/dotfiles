## Codex CLI 共通指示（dotfiles）

- 返答/レビュー/ドキュメントは **日本語** をデフォルトにする
- 作業は **Explore → Plan → Implement → Verify** の順で進める（小さな変更はPlan省略可）
- **検証手段を必ず用意**する（テスト/ビルド/リンタ/期待出力）。検証なしの「それっぽい修正」で終えない
- 調査で大量に読む必要があるときは、作業を分割してプロンプト/出力を小さく保つ（コンテキスト節約）
- 変更前提の作業では、まず `git status` / `git diff` / `git log -5` を確認する
- `main` への直接 push はしない（ブランチ + PR）
- コマンド実行結果は、必要なら stdout で返す（ファイル経由に逃がしすぎない）

## カスタム skills

dotfiles は Codex のカスタム skills を `~/.codex/skills/custom/` に展開する。
主な入口は以下:

- `/fix <ISSUE_NUMBER>`: worktree 前提でTDD実装
- `/issue <ISSUE_NUMBER>`: Issue作成/確認
- `/review <PR_NUMBER>`: PRの静的レビュー（ローカルに保存）
- `/planner`: 実装計画の作成
- `/architect`: 設計レビュー/ADR雛形
- `/tdd-runner`: TDD（Nested含む）の進行支援
- `/doc-updater`: 仕様/ドキュメント整合の更新支援
- `/ci-debugger`: CI失敗の調査・修正
- `/build-error-resolver`: ビルド/型エラー修正（最小差分）
- `/pr-creator`: PR作成（日本語タイトル）
- `/rebase-resolver`: rebaseコンフリクト解消
- `/review-checker`: PRレビューコメント監視と指摘対応
- `/refactor-cleaner`: 安全なリファクタ/掃除
- `/deadcode`: デッドコード（未使用コード）検出
- `/duplication`: 重複/類似コード検出
- `/coverage`: コードカバレッジ分析
- `/worktree-management`: worktree作成（必要時）
- `/e2e-runner`: E2E設計/実行
- `/video-splitter`: 動画分割（200MB等）

