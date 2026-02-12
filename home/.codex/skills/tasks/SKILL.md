---
name: tasks
description: "Obsidianのbacklog.mdとDailyノートのタスク欄を管理する。GitHub/Jira/Obsidianなど複数ソースからイシューを取得して正規化し、Dailyへ提案・バックログへ同期する。Usage: /tasks"
---

# Tasks Skill

このスキルは専用CLIに依存せず、エージェントが直接CLIを呼び出して運用する。
- Obsidianの操作は `obsidian task(s)` CLI を使う。

- `15_tasks/queue.md` を作業キューとして更新（SSoTは外部ソース）
- Daily ノートの `## タスク` を当日実行リストとして更新
- GitHub/Jira/Obsidian など複数ソースのイシューを共通形式で取り扱う
- Daily ノート形式は `デイリーログ / ノート / ポスト / タスク / つぶやき` を維持する
- 作業用スクリプトは `scripts/update-backlog.py` に集約する
- Taskは1行形式: `- [{status}] {title} [{identity}]`
- identityは独自スキーム: `tsks:{source}:{org}/{proj}:{key}`
- Obsidian実体タスクはノートに `task_id: <6chars>` を持たせ、identityは `tsks:obsidian:{vault}:{task_id}`
- Obsidian実体タスクのtitleはノートリンクにする（必要ならパス付き）
- 廃棄理由はタスク直下の子リストで記録する（`- reason: ...`）

## 基本フロー

1. 朝の開始時:
   - 取得ソースのCLI存在確認を行う（例: `which gh` / `which jira` / `which obsidian`）。
   - issue を取得する（GitHub/Jira/Obsidian など）。
   - GitHubは「自分がアサインされているオープンIssue」と「自分が管理するリポジトリのオープンIssue」を取得する。
   - GitHub PR（自分が管理するリポジトリのPR / レビュー依頼PR）も取得する。
   - `15_tasks/queue.md` の `## バックログ` を更新する（再生成）。
   - 当日の Daily `## タスク` に実行候補を反映する。
2. 日中:
   - ユーザーが Daily `## タスク` のチェックボックスを手動更新する。
3. 終了時:
   - Daily の完了/未完を読み取り、未完了を `backlog.md` に戻す。
   - 完了/廃棄は `scripts/reflect-daily.py` でソースに反映する。

## 取得ソースの扱い

- 取得コマンドは複数定義できる（例: `gh ...`, `jira ...`, `obsidian tasks ...`）。
- 各コマンドの出力は共通JSON形式へ正規化して扱う。
- 形式は `references/issue-interface.md` を参照。
- 正規化とバックログ更新は `scripts/update-backlog.py` を使用する。
- Jiraは `JIRA_ORG`（優先）/ `JIRA_SITE` / `~/.config/.jira/.config.yml` の `server` から org を決定する。
- Jiraの取得条件は `JIRA_JQL` で上書き可能（デフォルト: `assignee = currentUser()` + subTask を明示的に含める）。
- Jiraの完了遷移は `~/.config/local-env/tsks/config.yaml` の `jira.done_status` で上書き可能（デフォルト: `Done` / `完了`）。
- ローカル設定は `~/.config/local-env/tsks/config.yaml`（`TSKS_CONFIG` で上書き）。
  - `github.include_repos`: 取得対象リポジトリ（空ならowner全体）
  - `jira.projects`: 取得対象プロジェクトキー

## Obsidian CLI 運用
- 一覧取得: `obsidian tasks ...`（`daily`, `file=...`, `path=...`, `status="<char>"`, `verbose`）
- 1件更新: `obsidian task ...`（`ref=path:line`, `daily line=...`, `toggle`, `done`, `todo`, `status="<char>"`）
- `tasks verbose` は `file path + line番号 + 行内容` を返す。
- `all` はVault全体走査になりやすいので使わない。
- `done/todo` の挙動に依存せず、`status="<char>"` を主軸にする。

## 重要ルール

- `15_tasks/index.md` は Obsidian タスク一覧用途として維持し、バックログ本体にはしない。
- 作業キューは `15_tasks/queue.md` を既定とする。
