# Issue Interface

外部取得コマンドは、標準出力で JSON 配列を返す。

## 必須

- `title`: タスクタイトル

## 推奨

- `source`: 取得元名（例: `jira`, `obsidian`）
- `system`: 管理システム名（例: `jira`, `github`, `obsidian`）
- `organization`: 組織/ワークスペース
- `project`: プロジェクト名
- `key`: 外部システム上の識別子
- `url`: 外部リンク
- `ref`: 表示用参照
- `priority`: 優先度（`P0` など）
- `due`: 期限（`YYYY-MM-DD`）
- `updatedAt`: 更新日時（ISO8601）
- `estimate`: 見積り分

## 例

```json
[
  {
    "source": "jira",
    "system": "jira",
    "organization": "PxDT",
    "project": "KOTOWARI-tottarrow",
    "key": "KT-123",
    "title": "ログイン画面の不具合修正",
    "url": "https://example.atlassian.net/browse/KT-123",
    "ref": "KT-123",
    "priority": "P1",
    "due": "2026-02-12",
    "updatedAt": "2026-02-11T09:00:00+09:00",
    "estimate": 90
  }
]
```

## 実行例

```bash
# GitHub から取得
gh search issues --assignee @me --state open --json title,url,number,repository

# Jira から取得（出力を共通JSONへ整形）
jira issue list --assignee me --json \
  | jq '[.[] | {source:"jira", system:"jira", key:.key, title:.summary, url:.url}]'
```
