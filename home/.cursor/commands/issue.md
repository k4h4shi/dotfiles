---
description: "GitHub Issueを作成・確認する。Usage: /issue [ISSUE_NUMBER]"
---

# イシュー管理

## 概要

GitHub Issue を **作成・確認**する。あなたの運用（ディスカバリー⇄デリバリー）の「成果物=Issue」を増やす入口。

基本方針:

- **共有すべきコンテキストはスプリント親Issueに集約**する（随時コメントで更新）
- 各子Issueには **親Issueへの紐付け**を必ず残す（最小コメント）
- **トラッカーIssueは /fix 投入しない**（Plan のセルに置かない）。必要なら子Issueを作る/分割する

## 使用例

- `/issue` - 新規イシュー作成
- `/issue #123` - イシュー #123 の詳細確認

## いつ使うか（ディスカバリー/デリバリー）

- **ディスカバリー（Issueを積む/整理する）**
  - MTG議事録・調査/分析レポート・仕様の差分など、入力（根拠）から Issue を作る
  - 出力（成果物）: Issue（必要なら docs/ のファイル + そのPR）
- **デリバリー（/fix で消化する実行Issue）**
  - 仕様/テスト/実装を揃えてマージ可能なPRまで持っていく単位を Issue にする
  - 出力（成果物）: PR（＋必要な docs 更新）/ テスト結果 / セッションレトロ（短文でOK）

## 手順

### 新規作成

1. **下書き作成**

   簡潔なタイトル形式を使用してください（タイトルの命名ルールは後述）。

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   cat > /tmp/issue.md << 'EOF'
   ## スプリント親Issue
   <!-- Parent sprint: #123 -->

   ## 種別
   <!-- discovery | delivery | tracker -->

   ## 概要
   <!-- 何を実現したいか -->

   ## 背景
   <!-- なぜ必要か -->

   ## 影響範囲（変更の当たり）
   - レイヤ: <!-- Presentation/Service/Domain/Repository/DB -->
   - 画面: <!-- 画面/ルート -->
   - データ: <!-- 触るテーブル/採番/enum 等 -->

   ## 参照（根拠/SSOT/ログ）
   - <!-- docs/ のパス、議事録、PR、CIログ、スクショ等 -->

   ## 非ゴール（やらないこと）
   - <!-- スコープを固定する -->

   ## 完了条件
   - [ ] 条件1

   ## テスト観点
   - [ ] Unit
   - [ ] Integration
   - [ ] E2E
   EOF
   ```

2. **ユーザーと内容確認・修正**

3. **イシュー作成**

   #### タイトル命名ルール（重要）

   - **タイトルは日本語で読みやすく**（例: `ログイン機能の実装`）
   - **`feat:` / `fix:` / `chore:` / `spec:` のような接頭辞は付けない**
     - 種別は **ラベル**で表現する

   #### ラベル運用（推奨）

   - 例: `enhancement`, `bug`, `documentation`, `question`, `meeting`, `sprint`
   - `種別`（discovery/delivery/tracker）は本文で明示し、ラベルは用途（bug/docs/priority等）を付ける

   ```bash
   gh issue create --title "タイトル" --body-file /tmp/issue.md --label "documentation"
   rm /tmp/issue.md
   ```

4. **親Issueへ紐付けコメント**

   デリバリー（スプリント）に載せる場合は、**スプリント親Issue** に紐付ける。

   ```bash
   gh issue comment <子Issue番号> --body "Parent sprint: #<親Issue番号>"
   ```

### 詳細確認

```bash
gh issue view <番号>
```

## よくある落とし穴（重要）

- **トラッカーをセルに置かない**: トラッカー（まとめ/入口/調査結果の保管）は /fix 単位にしない。必要なら「実行用の子Issue」を切る
- **/fix できる粒度にする**: “仕様/テスト/実装が揃う”最小単位に寄せる（重い場合は Phase 分割）
