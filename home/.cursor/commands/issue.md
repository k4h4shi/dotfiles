---
description: Create or manage GitHub issues. Usage: /issue [ISSUE_NUMBER]
---

# イシュー管理

## 概要

GitHub イシューの作成・確認を行います。
並行開発ではコンテキストが散逸しやすいので、基本方針は次。

- **共有すべきコンテキストはスプリント親Issueに集約**する（随時コメントで更新）
- 各子Issueには **親Issueへの紐付け**を必ず残す（最小コメント）

## 使用例

- `/issue` - 新規イシュー作成
- `/issue #123` - イシュー #123 の詳細確認

## 手順

### 新規作成

1. **下書き作成**

   簡潔なタイトル形式を使用してください。

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   cat > /tmp/issue.md << 'EOF'
   ## Parent Sprint Issue
   <!-- Parent sprint: #123 -->

   ## 概要
   <!-- 何を実現したいか -->

   ## 背景
   <!-- なぜ必要か -->

   ## 影響範囲（変更の当たり）
   - Layer: <!-- Presentation/Service/Domain/Repository/DB -->
   - Screen: <!-- 画面/ルート -->
   - Data: <!-- 触るテーブル/採番/enum 等 -->

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

   タイトルは簡潔に記述してください（例: `ログイン機能の実装`）。

   ```bash
   gh issue create --title "タイトル" --body-file /tmp/issue.md
   rm /tmp/issue.md
   ```

4. **親Issueへ紐付けコメント**

   ```bash
   gh issue comment <子Issue番号> --body "Parent sprint: #<親Issue番号>"
   ```

### 詳細確認

```bash
gh issue view <番号>
```
