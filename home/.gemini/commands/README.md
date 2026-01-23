# Gemini CLI Commands

Gemini CLI用のカスタムコマンド。

## セッション振り返り

| コマンド | 用途 | 特徴 |
|:---------|:-----|:-----|
| `/retro` | 軽量振り返り | 要点抽出に特化、改善1〜3件に峻別 |
| `/session-retrospective` | 詳細振り返り | 6カテゴリの包括的分析 |

### `/retro` （推奨）

```bash
gemini /retro              # 最新セッションを分析
gemini /retro abc-123-def  # 指定セッションを分析
```

**特徴**:
- 要点のみを抽出（Pain Points, Permissions, 繰り返しパターン）
- 改善提案は1〜3件に絞る
- 「仕組みで潰せる」ものを優先

### `/session-retrospective` （詳細版）

```bash
gemini /session-retrospective [SESSION_ID]
```

**特徴**:
- 6カテゴリの包括的分析
  - Permissions
  - Memory / Rules
  - Skills
  - Agents
  - Hooks
- レポートをファイルに保存

## コードレビュー

### `/review`

```bash
gemini /review 123  # PR #123 をレビュー
```

PRのコードをプロジェクトガイドラインに基づいてレビュー。
