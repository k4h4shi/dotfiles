---
name: session-retrospective
description: セッション完了後に振り返り、設定改善を提案する。worktree作業完了時や /session-retrospective で呼び出す。
user-invocable: true
allowed-tools: Bash(python3:*), Read
---

# Session Retrospective

セッションログを分析し、Claude Code の設定改善を提案するスキル。

## 目的

- **許可待ちの削減** → `permissions` の改善提案
- **繰り返し指示の削減** → `skill` / `command` / `agent` の提案
- **コンテキスト不足の解消** → `.mdc` rules の提案

## 使い方

```bash
# カレントプロジェクトの最近5セッションを分析
/session-retrospective

# 分析するセッション数を指定
/session-retrospective --recent 10

# 特定プロジェクトを分析
/session-retrospective --project /path/to/project
```

## 実行手順

### Step 1: 分析スクリプトを実行

```bash
python3 ~/.claude/skills/session-retrospective/scripts/analyze.py [OPTIONS]
```

**オプション**:
- `--project PATH`: 分析対象のプロジェクトパス（省略時はカレントディレクトリ）
- `--recent N`: 分析するセッション数（デフォルト: 5）
- `--session-id ID`: 特定のセッションIDを分析

### Step 2: 分析結果を解釈

スクリプトは以下の形式で JSON を出力する:

```json
{
  "analyzed_sessions": 5,
  "permissions": {
    "suggested": ["Bash(cargo test:*)"],
    "occurrences": 3,
    "reason": "3回の許可待ちが発生"
  },
  "repeated_patterns": [
    {
      "type": "workflow",
      "pattern": "gh issue view → Glob docs → Read specs",
      "occurrences": 5,
      "suggestion": "issue-analyzer skill を作成"
    }
  ],
  "rules": [
    {
      "name": "suggested-rule-name",
      "reason": "説明が3回繰り返された",
      "keywords": ["keyword1", "keyword2"]
    }
  ],
  "ask_user_questions": [
    {
      "question": "繰り返された質問内容",
      "occurrences": 2,
      "suggestion": "rule として文書化"
    }
  ]
}
```

### Step 3: ユーザーへの提案

分析結果に基づき、以下を提案する:

1. **permissions**: `settings.json` に追加すべき許可ルール
2. **skills**: 作成すべきスキルのドラフト
3. **rules**: 作成すべき `.mdc` ルールのドラフト
4. **agents**: 定義すべきエージェントパターン

## 分析対象

| 検出パターン | 分析ソース | 提案先 |
|:------------|:----------|:------|
| 許可待ちが発生 | debug log | `settings.json` permissions |
| 同じ質問を繰り返した | session JSONL (AskUserQuestion) | `.mdc` rules |
| 複数セッションで類似指示 | session JSONL (user messages) | `SKILL.md` / `command` |
| 繰り返しの委譲パターン | session JSONL (Task tool) | `agent` 定義 |

## データソース

### Debug Log
`~/.claude/debug/<session-id>.txt`

許可に関するパターン:
```
Permission suggestions for <TOOL>: [...]
Applying permission update: Adding N allow rule(s) to destination '<dest>': [...]
```

### Session JSONL
`~/.claude/projects/<project>/<session-id>.jsonl`

```json
{"type": "user", "message": {"role": "user", "content": "..."}}
{"type": "assistant", "message": {"role": "assistant", "content": [...]}}
```

## 注意事項

- 分析結果はあくまで提案であり、実際に適用するかはユーザーの判断に委ねる
- 機密情報が含まれる可能性があるため、提案内容の確認を推奨
- 複数セッションを比較することで、より精度の高い提案が可能
