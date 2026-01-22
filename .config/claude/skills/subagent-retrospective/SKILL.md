---
name: subagent-retrospective
description: セッション完了後に Codex でレトロスペクティブを実行し、Claude Code の設定改善を提案する
disable-model-invocation: true
user-invocable: true
allowed-tools: Bash(codex:*)
---

# Subagent Retrospective

Codex CLI を使用して現在のセッションを分析し、Claude Code の設定改善を提案する。

## セッション情報

- **Session ID**: ${CLAUDE_SESSION_ID}
- **Project**: カレントディレクトリ

## 実行手順

### Step 1: Codex で retrospective を実行

セッション ID を引数として渡す:

```bash
codex exec "/session-retrospective ${CLAUDE_SESSION_ID}"
```

### Step 2: レポートを移動

Codex のサンドボックス制限により `/tmp` に保存されるため、**メインリポジトリ**の正しい場所に移動する。
worktree で作業している場合も、メインリポジトリに保存することで、worktree 削除後もレポートが残る。

```bash
# メインリポジトリのルートを取得（worktree対応）
MAIN_REPO=$(dirname "$(git rev-parse --git-common-dir)")
mkdir -p "${MAIN_REPO}/.claude/retrospectives"
mv /tmp/${CLAUDE_SESSION_ID}.md "${MAIN_REPO}/.claude/retrospectives/"
```

### Step 3: 結果を確認

```bash
MAIN_REPO=$(dirname "$(git rev-parse --git-common-dir)")
cat "${MAIN_REPO}/.claude/retrospectives/${CLAUDE_SESSION_ID}.md"
```

### Step 4: ユーザーに報告

Codex からの改善提案を要約して報告:

1. **Permissions**: 追加すべき許可ルール
2. **Memory / Rules**: 追記すべきプロジェクト知識
3. **Skills**: 作成すべきスキル
4. **Agents**: 定義すべきエージェント
5. **Hooks**: 追加すべきフック

優先度の高い提案から順に、具体的なアクションを提示する。
