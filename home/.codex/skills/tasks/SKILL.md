---
name: tasks
description: "Obsidianのbacklog.mdとDailyノートのタスク欄を管理する。GitHub/Jira/Obsidianなど複数ソースからイシューを取得して正規化し、Dailyへ提案・バックログへ同期する。Usage: /tasks"
---

# Tasks Skill

このスキルは専用CLIに依存せず、エージェントが直接CLIを呼び出して運用する。

- Vault ルート `backlog.md` をバックログSSOTとして更新
- Daily ノートの `## タスク` を当日実行リストとして更新
- GitHub/Jira/Obsidian など複数ソースのイシューを共通形式で取り扱う
- Daily ノート形式は `デイリーログ / ノート / ポスト / タスク / つぶやき` を維持する

## 基本フロー

1. 朝の開始時:
   - issue を取得する（GitHub/Jira/Obsidian など）。
   - `backlog.md` の `## バックログ` を更新する。
   - 当日の Daily `## タスク` に実行候補を反映する。
2. 日中:
   - ユーザーが Daily `## タスク` のチェックボックスを手動更新する。
3. 終了時:
   - Daily の完了/未完を読み取り、未完了を `backlog.md` に戻す。

## 取得ソースの扱い

- 取得コマンドは複数定義できる（例: `gh ...`, `jira ...`, `obsidian tasks ...`）。
- 各コマンドの出力は共通JSON形式へ正規化して扱う。
- 形式は `references/issue-interface.md` を参照。

## 重要ルール

- タスク識別情報はチェックボックス本文に露出させず、`tsks-meta` コメントに保持する。
- `15_tasks/index.md` は Obsidian タスク一覧用途として維持し、バックログ本体にはしない。
- バックログファイルは `backlog.md`（Vault ルート）を既定とする。
