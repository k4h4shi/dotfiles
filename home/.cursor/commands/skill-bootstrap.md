---
description: "新規プロジェクト参加時に、既存資産を調査してスキルを整備する。Usage: /skill-bootstrap"
---

# スキル作成（新規プロジェクト調査）

新規プロジェクトに参加したときに、**既存資産を確認した上で**スキルを整備するためのコマンド。
重複を避け、既存のスキルやドキュメントを最大限再利用する。

## 0. 参照

- 推奨スキル一覧: `dotfiles/docs/skill-catalog.md`

## 1. 現状調査（必須）

1) 既存スキルの有無を確認

```bash
ROOT="$(git rev-parse --show-toplevel)"
ls "$ROOT/.claude/skills" 2>/dev/null || true
ls "$ROOT/.gemini/skills" 2>/dev/null || true
```

2) コマンド/エージェント側の要求スキルを抽出

```bash
rg "Skill\\(" "$ROOT/.claude" "$ROOT/.gemini" "$ROOT/.cursor"
```

3) プロジェクト固有の参照ドキュメント候補を収集

```bash
rg -n "architecture|spec|design|readme|docs" "$ROOT" -g "*.{md,mdx}"
```

## 2. 重複回避ルール（重要）

- **同名スキルが存在する場合は新規作成しない**。内容を更新する。
- 類似スキルがある場合は、**既存スキルに追記して統合**する。
- スキル内では **共通エージェントの抽象手順を繰り返さない**。
  - 具体的な「参照ドキュメント」「コマンド」「失敗時復旧」に集中する。

## 3. 作成すべきスキルの決定

1) `skill-catalog.md` と現状スキルを比較して、**不足スキル**を列挙  
2) それぞれに「参照ドキュメント」「コマンド」「失敗時復旧」を埋める  
3) 既存スキルに吸収可能なら **新規作成せず更新のみ**

### 出力フォーマット

```markdown
# スキル棚卸し結果

## 1. 既存スキル
- [name] - [短い説明]

## 2. 不足スキル（作成/更新）
| Skill | Action | Reason |
| :--- | :--- | :--- |
| plan-guide | Update | 参照ドキュメントの明記が不足 |

## 3. 参照ドキュメント候補
- docs/architecture.md
- docs/spec.md

## 4. 次アクション
- [ ] plan-guide を更新（docs/architecture.md を追記）
- [ ] ci-debug を作成（CIの実行コマンドを記載）
```

## 4. スキル雛形

新規作成時は以下の最小構成で作る。

```markdown
---
name: <skill-name>
description: <project-specific>
allowed-tools: Read, Grep, Glob, Bash
---

# <Skill Title>

## 参照ドキュメント
- <doc path>

## 実行コマンド
~~~bash
<commands>
~~~

## 失敗時の復旧
- <fallback>
```
