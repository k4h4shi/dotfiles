---
description: "Issueを収集し、スプリントゴール/親Issue/レーン/クリティカルパスを設計する。Usage: /plan"
---

# 計画（プラン）と優先順位付け

このコマンドは、オープンIssueを収集して優先順位付けし、**並行スプリント計画**（スプリントゴール＋親Issue＋レーン＋クリティカルパス）を設計する。

## 1. Issueを取得

まず GitHub からオープンIssueを取得し、現状の作業量を把握する。

```bash
gh issue list --limit 100 --state open --json number,title,labels,updatedAt,assignees
```

## 2. 分析と優先順位付け（スプリントゴール前提）

取得したIssueとプロジェクトゴール（必要なら repo の `AGENTS.md` と SSOT の `docs/`）を根拠に、タスクを分析する。

### 2.1 Sprint Goal（最重要）
並行開発は迷子になりやすいので、**最初にスプリントゴールを1文で固定**する。

- 例: 「見積の主ラインを前進させる（回帰止血→一覧UX→採番基盤）」
- ゴールに含めない（Not in sprint）も明記する（“やらないこと”が迷子防止になる）

## 3. スプリント親Issueを作成（コンテキストの集約点）
並行実行では「どこに向かっているか」を見失いやすい。
そのため、スプリント開始時に **スプリント親Issue** を1つ作り、以後の共有コンテキストはそこに集約する。

- 親Issueには以下を含める:
  - Sprint Goal / Not in sprint / DoD
  - レーン図（Mermaid）
  - 進捗更新ログ（完了/追加観点/ブロッカー/方針変更）
  - レトロの要点（改善1〜3件）

### 作成例
```bash
gh issue create --title \"sprint: <プロジェクト名> / <期間 or 連番>\" --body \"$(cat <<'EOF'
## Sprint Goal
- Goal: <1文>
- Not in sprint:
  - <やらないこと>
- DoD:
  - <観測可能な条件>

## Lanes
```mermaid
graph LR
  subgraph \"Lane A: Migration（直列）\"
    A1[\"#169 ...\"] --> A2[\"#170 ...\"]
  end
  subgraph \"Lane B: Regression（並行OK）\"
    B1[\"#190 ...\"]
  end
  subgraph \"Lane C: Feature/UX（並行OK）\"
    C1[\"#174 ...\"]
  end
  subgraph \"Lane D: Enablement（改善）\"
    D1[\"#194 ...\"]
    D2[\"#195 ...\"]
  end
```

## Updates（随時追記）
- YYYY-MM-DD: kickoff

## Retro（スプリント末に追記）
- TBD
EOF
)\"
```

## 4. レーン設計（並行実行の設計）
Issueをレーンに割り当てる。特に **Migration系は直列（1本）** を徹底する。

推奨レーン:
- Lane A: Migration（直列）
- Lane B: Regression / Follow-ups（並行OK）
- Lane C: Feature / UX（並行OK）
- Lane D: Enablement（改善・並行OK、1〜3件に絞る）

### 出力フォーマット

分析結果は以下のマークダウン形式で出力する:

```markdown
# Project Plan Analysis

## 0. Sprint Goal
- **Goal**: <1文>
- **Not in sprint**:
  - <やらないこと>
- **Definition of Done (DoD)**:
  - <観測可能な完了条件（PR/テスト/画面/仕様更新）>

## 1. Parallel Execution Map

依存関係を分析し、レーン（Lane）で Mermaid 図を示す。

\`\`\`mermaid
graph LR
  subgraph "Lane A: Migration（直列）"
    A1["#169 ..."] --> A2["#170 ..."]
  end
  subgraph "Lane B: Regression（並行OK）"
    B1["#190 ..."]
  end
  subgraph "Lane C: Feature/UX（並行OK）"
    C1["#174 ..."]
  end
  subgraph "Lane D: Enablement（改善）"
    D1["#194 ..."]
    D2["#195 ..."]
  end
\`\`\`

**並行実装の判断基準**:
- 同一ファイルを編集しない
- 依存する機能がない
- 独立してテスト可能
- Migration/採番/DBなど“波及する基盤”は同時に走らせない

## 2. Critical Path
- **Goal**: [Sprint Goal]
- **Blocking**: [List of blocking issues]
- **Path**: [Issue A] -> [Issue B] -> [Goal]

## 3. Priority List
| Priority | Issue | Title | Parallel Group | Reasoning |
| :--- | :--- | :--- | :--- | :--- |
| P0 | #123 | Title | Phase 1 | [Reason for high priority] |
| P0 | #124 | Title | Phase 1 | [Can run in parallel with #123] |
| P1 | #125 | Title | Phase 2 | [Depends on #123, #124] |

## 4. Recommendations
- **Parallel Tasks**: [List issues that can be implemented in parallel using worktrees]
- **Next Action**: [What to do next]
- **Missing Tasks**: [Any necessary tasks not yet tracked as issues]

## 5. コンテキスト共有ポリシー（Issueコメントで残すべき最小情報）
並行実行の迷子防止のため、次を徹底する。

1) **共有すべきコンテキストは親Issueに集約**して随時コメントする（/status 相当）。  
2) 各子Issueは「親Issueへの紐付け」だけを必ず残す（最小）。

### 子Issueの最小コメント（紐付け）
```bash
gh issue comment <CHILD_ISSUE_NUMBER> --body \"Parent sprint: #<PARENT_ISSUE_NUMBER>\"
```

### 親Issueへの状況更新（例）
```bash
gh issue comment <PARENT_ISSUE_NUMBER> --body \"$(cat <<'EOF'
## Update YYYY-MM-DD
- Done: #190（選択UIの欠落防止）PR #...
- New context: <追加で分かった仕様/衝突>
- Blockers: <詰まり>
- Next: <次の一手>
EOF
)\"
```
```

## 6. 次アクション

ユーザーに次のどちらを行うか確認する:
1. 足りないタスクをIssue化する（`gh issue create`）
2. 最優先Issueの作業を開始する（`/fix <issue_number>`）
