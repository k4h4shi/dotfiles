# Session Retrospective

特定の Claude Code セッションを分析し、設定改善を提案するスキル。

---
description: Claude Codeのセッションを分析し、設定改善案を提案する。Usage: /session-retrospective [SESSION_ID]
---

## 参考ドキュメント

改善提案を行う際は、以下の公式ドキュメントを参照:
- Memory: https://code.claude.com/docs/en/memory
- Skills: https://code.claude.com/docs/en/skills
- Custom Slash Commands: https://code.claude.com/docs/en/slash-commands#custom-slash-commands
- Sub-agents: https://code.claude.com/docs/en/sub-agents
- Hooks: https://code.claude.com/docs/en/hooks-guide

## 設定ファイルの種類

| 種類 | 場所 | 用途 |
|:-----|:----|:----|
| Memory | `CLAUDE.md`, `.claude/CLAUDE.md` | プロジェクト知識、コーディング規約 |
| Rules | `.claude/rules/*.md` | パス指定可能なモジュラールール |
| Skills | `.claude/skills/<name>/SKILL.md` | スラッシュコマンド、自動実行ワークフロー |
| Agents | `.claude/agents/<name>.md` | 特化型サブエージェント |
| Hooks | `settings.json` の `hooks` | ライフサイクルフック |
| Permissions | `settings.json` の `permissions.allow` | ツール許可ルール |

## 実行手順

### Step 1: 対象セッションを特定

**引数**: `$ARGUMENTS` にセッション ID が渡される（例: `/session-retrospective abc-123-def`）

1. 引数でセッション ID が指定されていればそれを使用
2. 指定がなければ、カレントプロジェクトの最新セッションを使用

セッションログは以下の場所を順に探す:
1. **リポジトリローカル**: `.claude/sessions/` 配下
2. **グローバル**: `~/.claude/projects/${PROJECT_DIR_NAME}*/` 配下

```bash
# 引数からセッション ID を取得（なければ最新を探す）
SESSION_ID="$ARGUMENTS"

if [ -z "$SESSION_ID" ]; then
  # まずリポジトリローカルを探す
  SESSION_FILE=$(ls -t .claude/sessions/*.jsonl 2>/dev/null | head -1)

  # なければグローバルを探す
  if [ -z "$SESSION_FILE" ]; then
    PROJECT_DIR_NAME=$(pwd | sed 's|/|-|g')
    SESSION_FILE=$(ls -t ~/.claude/projects/${PROJECT_DIR_NAME}*/*.jsonl 2>/dev/null | head -1)
  fi

  SESSION_ID=$(basename "$SESSION_FILE" .jsonl)
fi

# セッションファイルを探す（ローカル優先）
SESSION_FILE=$(find .claude/sessions -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)
if [ -z "$SESSION_FILE" ]; then
  SESSION_FILE=$(find ~/.claude/projects -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)
fi
```

### Step 2: セッションログを読み込む

```bash
# セッションファイル（JSONL形式）
cat "$SESSION_FILE"

# デバッグログ（あれば）
cat ~/.claude/debug/${SESSION_ID}.txt 2>/dev/null
```

### Step 3: 分析と改善提案

**1. セッションの概要**
- ユーザーが何を達成しようとしていたか
- 実際に何が行われたか
- 成功/失敗/中断したタスク

**2. Permissions の改善**
- デバッグログから `Permission suggestions for` を検出
- どのコマンドで許可待ちが発生したか
- **提案**: `settings.json` の `permissions.allow` に追加すべきルール
  ```json
  { "permissions": { "allow": ["Bash(npm test:*)"] } }
  ```

**3. Memory / Rules の改善**
- ユーザーが繰り返し説明したプロジェクト知識
- Claude が AskUserQuestion で確認した内容
- **提案**: `CLAUDE.md` または `.claude/rules/*.md` に追記すべき内容
  ```markdown
  # .claude/rules/testing.md
  ---
  paths: ["src/**/*.test.ts"]
  ---
  - テストは Jest を使用
  - モックは __mocks__ ディレクトリに配置
  ```

**4. Skills の改善**
- 繰り返し実行されたワークフロー
- 手動で毎回指示していた一連の操作
- **提案**: `.claude/skills/<name>/SKILL.md` として定義
  ```yaml
  ---
  name: deploy-preview
  description: Preview 環境にデプロイする
  disable-model-invocation: true
  allowed-tools: Bash(npm:*), Bash(gh:*)
  ---
  1. npm run build
  2. npm run deploy:preview
  3. gh pr comment で URL を共有
  ```

**5. Agents の改善**
- 特定タスクへの繰り返しの Task 委譲
- 同じツール制限/プロンプトパターン
- **提案**: `.claude/agents/<name>.md` として定義
  ```yaml
  ---
  name: test-runner
  description: テストを実行し、失敗を分析する
  tools: Read, Bash, Grep
  model: haiku
  ---
  テストを実行し、失敗があれば原因を分析してください。
  ```

**6. Hooks の改善**
- 毎回手動で行っていた前処理/後処理
- ファイル編集後のフォーマット、コミット前のチェック等
- **提案**: `settings.json` の `hooks` に追加
  ```json
  {
    "hooks": {
      "PostToolUse": [{
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "prettier --write ..." }]
      }]
    }
  }
  ```

### Step 4: レポートを作成・保存

**重要**: レポートは**メインリポジトリ**の `.claude/retrospectives/<BRANCH_NAME>.md` に保存する。
worktree で作業している場合も、メインリポジトリに保存することで、worktree 削除後もレポートが残る。

```bash
# メインリポジトリのルートを取得（worktree対応）
MAIN_REPO=$(dirname "$(git rev-parse --git-common-dir)")
mkdir -p "${MAIN_REPO}/.claude/retrospectives"

# ブランチ名を取得（スラッシュはハイフンに変換）
BRANCH_NAME=$(git branch --show-current | tr '/' '-')
# レポートは ${MAIN_REPO}/.claude/retrospectives/${BRANCH_NAME}.md に保存
```

```markdown
# Session Retrospective: <BRANCH_NAME>

**Date**: YYYY-MM-DD HH:mm
**Branch**: `<BRANCH_NAME>`

## Session Summary

[このセッションで何が行われたかの概要]

## What Went Well

- [うまくいったこと]

## Suggested Improvements

### 1. Permissions (`settings.json`)

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test:*)",
      "Bash(gh pr:*)"
    ]
  }
}
```

**理由**: [許可待ちが N 回発生]

### 2. Memory (`CLAUDE.md` or `.claude/rules/`)

```markdown
# 追記すべき内容
```

**理由**: [この知識を N 回説明した]

### 3. Skills (`.claude/skills/<name>/SKILL.md`)

```yaml
---
name: suggested-skill
description: ...
---
```

**理由**: [このワークフローを N 回実行した]

### 4. Agents (`.claude/agents/<name>.md`)

```yaml
---
name: suggested-agent
description: ...
tools: Read, Grep
---
```

**理由**: [この委譲パターンが N 回発生]

### 5. Hooks (`settings.json`)

```json
{
  "hooks": { ... }
}
```

**理由**: [この後処理を毎回手動で行った]

## Action Items

- [ ] 具体的なアクション1
- [ ] 具体的なアクション2
```

### Step 5: ユーザーに報告

1. レポートのパスを表示
2. 主要な改善提案を簡潔に説明
3. 優先度の高いアクションを提示

## Step 6: プロジェクト固有の改善提案

プロジェクト固有の設定改善が必要な場合、**プロジェクトの管理方法に従って**提案する。

### 手順

1. **プロジェクトの AI 設定管理方法を確認**
   - `CLAUDE.md` に記載があるか確認
   - `.claude/rules/` にルールがあるか確認
   - 既存の設定ファイルの管理方法（同一リポ / 別リポ / dotfiles 等）を把握

2. **プロジェクトの方法に従って改善を提案**
   - 管理方法が明記されていれば、それに従う
   - 明記されていなければ、ユーザーに確認

3. **改善内容をレポートに含める**

### ユーザーへの報告

```markdown
## 改善提案

以下の改善点が見つかりました:

### Permissions
- [改善内容]

### Memory / Rules
- [改善内容]

### Skills
- [改善内容]

---
**適用方法**: プロジェクトの設定管理ルールに従ってください。
管理方法が不明な場合はお知らせください。
```

## 注意事項

- 分析結果はあくまで提案であり、最終判断はユーザー
- 機密情報が含まれる可能性があるため、レポートの共有には注意
- グローバル設定（dotfiles）は変更しない。プロジェクト固有設定のみ対象
