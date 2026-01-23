---
description: GitHubの活動（クローズIssue/マージPR）から日報を生成する。Usage: /daily-report
---

# 開発日報の生成

`docs/research/YYYYMMDD_daily_report.md` に、今日のGitHub活動を要約した日報を出力する。

並行スプリント運用の場合は、以下も簡潔にまとめる:
- スプリントゴール（現在）
- レーン状況（何が進んだ / 何が詰まっている）
- Enablement（改善）がどこまで入ったか

## 手順

1.  **活動データの取得**:

    - 今日の日付（YYYY-MM-DD）を取得する
    - `gh` でクローズIssue / マージPRを取得する
    - **注意**: `gh` の検索式が不安定な場合があるので、日付フィルタは `jq` で行う

    ```bash
    TODAY=$(date +%Y-%m-%d)
    REPORT_FILE="docs/research/$(date +%Y%m%d)_daily_report.md"
    mkdir -p .tmp

    # クローズIssue（当日分を拾うため上限50）
    gh issue list --state closed --limit 50 --json number,title,closedAt | jq -r --arg DATE "$TODAY" '.[] | select(.closedAt >= $DATE)' > .tmp/closed_today.json

    # マージPR（当日分を拾うため上限50）
    gh pr list --state merged --limit 50 --json number,title,mergedAt | jq -r --arg DATE "$TODAY" '.[] | select(.mergedAt >= $DATE)' > .tmp/merged_today.json
    ```

2.  **日報の下書きを生成**:

    - 取得したデータから日報ファイルを作る

    ```bash
    echo "# 開発日報 ($TODAY)" > "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "## 本日のハイライト" >> "$REPORT_FILE"
    echo "<!-- AI: Please summarize the highlights here -->" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "## 完了したタスク" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    echo "### Issues (Closed)" >> "$REPORT_FILE"
    jq -r '.[] | "- " + .title + " (#" + (.number|tostring) + ")"' .tmp/closed_today.json >> "$REPORT_FILE"

    echo "" >> "$REPORT_FILE"
    echo "### Pull Requests (Merged)" >> "$REPORT_FILE"
    jq -r '.[] | "- " + .title + " (#" + (.number|tostring) + ")"' .tmp/merged_today.json >> "$REPORT_FILE"

    echo "" >> "$REPORT_FILE"
    echo "## 次のアクション" >> "$REPORT_FILE"
    echo "- [ ] " >> "$REPORT_FILE"
    ```

3.  **内容の整形**:
    - 下書きの `$REPORT_FILE` を読む
    - Issue/PRタイトルと直近文脈をもとに、「本日のハイライト」を**意味が通る文章**に書き直す
    - 可能なら分類する（例: Feature / Fix / Docs）
    - 追記: **Sprint Goal / Lane progress / Blockers** を各1〜3点で短く書く
    - **生成したファイルパス**をユーザーに提示する
