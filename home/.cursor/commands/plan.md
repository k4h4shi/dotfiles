---
description: "Issueを収集し、スプリントゴール/親Issue/レーン/クリティカルパスを設計する。Usage: /plan"
---

# 計画（プラン）と優先順位付け

このコマンドは、GitHub のオープンIssue（=ディスカバリーの成果物）を材料に、デリバリー（スプリント）の **並行スプリント計画**（スプリントゴール＋親Issue＋レーン＋クリティカルパス）を設計する。

前提:
- 情報は GitHub に集約する（Issue/PR/Docs/CIログ）
- **プランは常にゼロベース**（前回スプリントの計画/レーン配置/優先度を前提にしない）
- 前回スプリントの影響は「Issue がクローズされた/追加された」という事実で十分（=現時点のIssue一覧に反映されている）
- **セル=Issue（/fix投入単位）**
- **トラッカーIssueはセルに置かない**（必要なら子Issueを作る/Phase分割する）

## 0.0 ゼロベース原則（最重要）

毎回、**現時点のオープンIssue** を起点に探索し、フレッシュに計画する。

- 過去のスプリント親Issue/Plan Matrix を **参照して引き継がない**
- 例外は「SSOT（docs）」「現時点のIssue本文/PR/CIログ」など **今も有効な一次情報**のみ

## 0. 重要（次回以降の迷子防止）

### 0.1 Sprint Goal は「体験できる価値」を書く
スプリント完了後に **アプリを触って変化を体験できる** ゴールを必ず書く。

- **Goal（価値）**: 1〜2文で「何がどう良くなるか」を言い切る
- **After Sprint（体験）**: 「どの画面で何が変わるか」を具体に書く
- **Try it（触って確認）**: 3〜7手順の手動確認手順（クリック順）を入れる
- **Not in sprint**: 今回やらないこと（迷子防止）

#### 0.1.1 価値提供を「連続」にする（スプリントの設計原則）
計画は “タスクを終わらせる” ではなく、**連続的な価値提供**（毎スプリント、触って分かる変化）を中心に組む。

- **スプリントはデモ可能な増分**（小さくても良い）を必ず含める
- **縦スライス**（UI + 仕様/テスト + 必要ならDB）を優先し、横断リファクタは後ろに倒す/小さく切る
- 「完了したら誰も触らない」を避けるため、**レビュー時に触れる導線（Try it）をDoDに含める**

#### 0.1.2 ステップ分割は「POの成果が明確になる軸」を優先する
並行数を増やしても、スプリントの意味（何が成し遂げられたか）が曖昧になるなら失敗する。\n
そのため、ステップ（スプリント）の分割は依存関係だけでなく、**POの成果が明確になる軸（体験のまとまり）**で切る。\n

- **1スプリント=1〜3個の“体験できる変更”** に絞る（多すぎると誰も触らない）
- **スプリント完了の意味**が一言で言えること（例:「見積作成が迷わずできるようになった」）
- 依存が無いタスクでも、体験軸がズレるなら **次スプリントへ送る**（WIP制限）
- 逆に、依存があっても同じ体験のために必要なら **同一スプリント内で縦に切って含める**（Phase/サブIssue化）

### 0.2 エージェントへの指示は Issue で行う（セル=Issue）
計画の最終アウトプットは **レーン=エージェント（並列セッション枠） / ステップ=スプリント** のマトリクスで、**各セルには1つのIssueだけ**を置く。

- **レーン**: “同じ担当が継続する”の意味ではなく、同一スプリント内の **並列 /fix セッション枠**
- **ステップ**: スプリント（同期点）。完了した成果が次スプリントへ引き継がれる
- **セル**: `/fix <issue_number>` の投入単位（= Issue）

#### 0.2.1 トラッカーIssueの扱い（重要）
- **トラッカーは/ fix 投入しない**（セルに入れない）
- トラッカー配下の「実行すべき変更」は **子Issue（/fix可能な粒度）** として起票し、Plan Matrix のセルに置く

### 0.3 粒度調整ルール（必要なら統合/分割する）
- **まとめる（統合）**: 「一気に1セッションで完了させるべき」複数Issueは、**実行用の統合Issueを新規作成**してそこに集約する  
  - 既存Issueは「統合先Issue」をコメントしてClose（追跡のSSOTを1つに）
- **分ける（Phase分割）**: 1Issueが重く、複数スプリント/複数実行セッションに跨がるなら **Phase Issue** に分割する  
  - 元Issueは **トラッカー** にして「/fixしない」を明記し、Phase Issueをリンクする
- **依存明文化**: 依存がある場合は、Issue本文に `Depends on: #123` を明示して、ステップ計算に反映できる状態にする

### 0.4 指示の取り違えを防ぐ（解釈スナップショット）
曖昧さを残したまま進めると手戻りが増えるため、/plan の出力には **解釈のスナップショット**を必ず含める（確認質問で止めるのではなく、差分が見える形で提示する）。

- **Constraints（制約）**: 例）「セル=Issue」「指示はIssueで」「既存Issueの統合/分割方針」など
- **Assumptions（前提）**: 今回そう置いた前提（例）「このIssueはトラッカーとして扱う」など
- **Ambiguities（曖昧点）**: 分岐し得る点（例）「E2Eは影響あれば修正/なければ報告」など
- **Decisions（判断）**: どちらに倒したか（根拠付き）

## 1. Issueを取得

まず GitHub からオープンIssueを取得し、現状の作業量を把握する。

```bash
gh issue list --limit 300 --state open --json number,title,labels,updatedAt,assignees
```

## 2. 分析と優先順位付け（スプリントゴール前提）

取得したIssueとプロジェクトゴール（必要なら repo の `AGENTS.md` と SSOT の `docs/`）を根拠に、タスクを分析する。

### 2.0 ディスカバリーの健全性チェック（軽く）
スプリントに入れる前に、バックログ（Issue）が「実行可能」になっているかを見る。
- トラッカー/調査結果は **セルに置かない**（必要なら子Issue化）
- 重いIssueは Phase 分割して、/fix 単位に落とす

### 2.1 Sprint Goal（最重要 / 体験ベース）
並行開発は迷子になりやすいので、**最初にスプリントゴールを固定**する。ここでは「スプリント完了後にアプリを触って何が変わったか」が分かる形にする。

- **Goal（価値）**: <1〜2文>
- **After Sprint（体験）**:
  - <どの画面で/何がどう変わるか>
- **Try it（手動確認手順）**:
  1. <手順>
  2. <手順>
  3. <手順>
- **Not in sprint**:
  - <やらないこと>

### 2.2 「価値の縦スライス」単位でスプリントに載せる
次を満たすまとまりを、優先的にスプリントへ載せる（タスク消化ではなく“価値”単位）。

- **User journey**: どのユーザーが、どの画面で、何を達成できるようになるか
- **Acceptance**: 仕様（SSOT）/テスト/実装が揃う最小単位
- **Demo**: スプリントレビューで「触って見せられる」状態

（横断的な改善やリファクタは、上記を支える最小分だけスプリントに混ぜる）

## 3. スプリント親Issueを作成（コンテキストの集約点）
並行実行では「どこに向かっているか」を見失いやすい。
そのため、スプリント開始時に **スプリント親Issue** を1つ作り、以後の共有コンテキストはそこに集約する。

- 親Issueには以下を含める:
  - Sprint Goal（体験ベース） / Not in sprint / DoD
  - Plan Matrix（レーン=エージェント / ステップ=スプリント、セル=Issue）
  - 依存関係（硬い依存）
  - After Sprint（体験）/ Try it（手動確認手順）
  - 解釈スナップショット（Constraints / Assumptions / Ambiguities / Decisions）
  - 進捗更新ログ（完了/追加観点/ブロッカー/方針変更）
  - レトロの要点（改善1〜3件）

### 作成例
```bash
gh issue create --title \"sprint: <プロジェクト名> / <期間 or 連番>\" --body \"$(cat <<'EOF'
## Sprint Goal
- Goal: <価値の1〜2文>
- After Sprint（体験）:
  - <どの画面で何が変わるか>
- Try it（手動確認手順）:
  1. <手順>
  2. <手順>
  3. <手順>
- Not in sprint:
  - <やらないこと>
- DoD:
  - <観測可能な条件>

## Plan Matrix（レーン=エージェント / ステップ=スプリント、セル=Issue）
- ルール: **各セルは1つのIssueのみ**（/fix投入単位）
| Lane | Sprint 1 | Sprint 2 | Sprint 3 |
| :-- | :-- | :-- | :-- |
| Lane-A | #123 | #130 |  |
| Lane-B | #124 |  |  |
| Lane-C | #125 | #131 | #140 |

## Dependencies（硬い依存）
- #123 -> #130
- #125 -> #131 -> #140

## Interpretation Snapshot（解釈スナップショット）
- Constraints:
  - <制約>
- Assumptions:
  - <前提>
- Ambiguities:
  - <曖昧点>
- Decisions:
  - <判断と根拠>

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

### 4.1 セル=Issueを満たすための粒度調整（必須）
マトリクスを作る前に、Issueの粒度を整える。

- **統合が必要**: 1セッションで一気にやるべきものが複数Issueに割れている  
  → 統合Issueを新規作成 → 既存IssueをCloseして統合先をコメント
- **分割が必要**: 1Issueが重く、複数スプリントに跨がる/複数セッションが必要  
  → Phase Issueを複数作成（`Depends on`を明記）→ 元Issueはトラッカーへ

### 4.2 依存関係の確定（必須）
依存があるのに本文に書かれていない場合は、計画作成の一環として **Issue本文を更新**して `Depends on: #NNN` を明文化する。

### 4.3 スプリントごとに「触れる成果」を必ず含める（DoDの必須項目）
- **Try it** が親Issueにあり、スプリントレビューで実際に触れる
- 変更点が分かるように、親Issueに「Changed UI / Behavior」を1〜5行で追記（リリースノートの種）

### 出力フォーマット

分析結果は以下のマークダウン形式で出力する:

```markdown
# Project Plan Analysis

## 0. Sprint Goal
- **Goal（価値）**: <1〜2文>
- **After Sprint（体験）**:
  - <どの画面で何が変わるか>
- **Try it（手動確認手順）**:
  1. <手順>
  2. <手順>
  3. <手順>
- **Not in sprint**:
  - <やらないこと>
- **Definition of Done (DoD)**:
  - <観測可能な完了条件（PR/テスト/画面/仕様更新）>

## 1. Plan Matrix（レーン=エージェント / ステップ=スプリント、セル=Issue）
| Lane | Sprint 1 | Sprint 2 | Sprint 3 |
| :-- | :-- | :-- | :-- |
| Lane-A | #123 | #130 | |
| Lane-B | #124 | | |
| Lane-C | #125 | #131 | #140 |

**並行実装の判断基準**:
- 同一ファイル/同一関心領域を同時に編集しない（衝突回避）
- 依存する機能がない
- 独立してテスト可能
- Migration/採番/DBなど“波及する基盤”は同時に走らせない

## 2. Critical Path
- **Goal**: [Sprint Goal]
- **Blocking**: [List of blocking issues]
- **Path**: [Issue A] -> [Issue B] -> [Goal]
- **Max Steps**: <依存チェーンの最長長>

## 2.1 Interpretation Snapshot（解釈スナップショット）
- **Constraints**: [...]
- **Assumptions**: [...]
- **Ambiguities**: [...]
- **Decisions**: [...]

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
