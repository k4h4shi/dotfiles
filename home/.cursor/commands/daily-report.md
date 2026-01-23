---
description: Generate a daily report based on GitHub activity (Closed Issues & Merged PRs). Usage: /daily-report
---

# Generate Daily Report

Generate a daily report file in `docs/research/YYYYMMDD_daily_report.md` summarizing today's GitHub activities.

In parallel sprint mode, also summarize:
- Sprint Goal (current)
- Lane status (what moved / what is blocked)
- Enablement progress (improvements shipped)

## Steps

1.  **Fetch Activity Data**:

    - Get today's date (YYYY-MM-DD).
    - Fetch closed issues and merged PRs using `gh`.
    - **Note**: Use `jq` to filter by date because `gh` search syntax might be unstable.

    ```bash
    TODAY=$(date +%Y-%m-%d)
    REPORT_FILE="docs/research/$(date +%Y%m%d)_daily_report.md"
    mkdir -p .tmp

    # Fetch Closed Issues (limit 50 to cover the day)
    gh issue list --state closed --limit 50 --json number,title,closedAt | jq -r --arg DATE "$TODAY" '.[] | select(.closedAt >= $DATE)' > .tmp/closed_today.json

    # Fetch Merged PRs
    gh pr list --state merged --limit 50 --json number,title,mergedAt | jq -r --arg DATE "$TODAY" '.[] | select(.mergedAt >= $DATE)' > .tmp/merged_today.json
    ```

2.  **Generate Draft Report**:

    - Create the report file with the fetched data.

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

3.  **Refine Content**:
    - Read the drafted `$REPORT_FILE`.
    - Based on the titles of issues and PRs, and recent context, **rewrite the "Highlights" section** to provide a meaningful summary.
    - Categorize the tasks if possible (e.g., Features, Fixes, Docs).
    - Add a short section: **Sprint Goal / Lane progress / Blockers** (1-3 bullets each).
    - **Display the path of the generated file** to the user.
