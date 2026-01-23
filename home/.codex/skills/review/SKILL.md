---
name: review
description: "PRのコードを静的レビューし、結果をローカルファイルに出力する。Usage: /review [PR_NUMBER]"
---

# ローカルコードレビュー

Pull Requestのコードを静的レビューし、結果を **ローカルファイル** に出力する。
**PR への自動投稿は行わない**（必要ならユーザーが手動で反映する）。

## 1. PR情報を取得

```bash
# PR番号が引数で渡されている場合はそれを使用
# なければ現在のブランチのPRを取得
PR_NUMBER=${1:-$(gh pr view --json number -q .number 2>/dev/null)}

# PR情報を取得
gh pr view $PR_NUMBER --json headRefName,baseRefName,title,body
```

## 2. Worktree の確認・作成

1. **既存の worktree を確認**:
   ```bash
   git worktree list
   ```
   - `headRefName` に対応する worktree があればそこを使う
   - なければ作成する

2. **Worktree 作成（必要な場合のみ）**:
   ```bash
   # リポジトリルートに移動
   cd $(git rev-parse --show-toplevel)

   # worktree ディレクトリを作成
   mkdir -p .worktrees

   # worktree を追加（リモートブランチをチェックアウト）
   git fetch origin <headRefName>
   git worktree add .worktrees/<headRefName> origin/<headRefName>
   ```

3. **worktree に移動**:
   ```bash
   cd .worktrees/<headRefName>
   ```

## 3. 変更ファイルを取得

```bash
# ベースブランチとの差分を取得
git diff --name-only origin/<baseRefName>...HEAD
```

## 4. レビューガイドラインを確認

以下のファイルがあれば読み、レビュー観点として参照する:

- `AGENTS.md`
- `CLAUDE.md`
- `docs/` ディレクトリ
- `.cursor/rules/`
- `.codex/instructions.md`

## 5. コードをレビュー

変更されたファイルを1つずつ読み、以下の観点でレビュー:

### レビュー観点

1. **バグ・ロジックの誤り**
   - 境界条件、null チェック、例外処理
2. **セキュリティ問題**
   - インジェクション、認証・認可の不備
3. **仕様・要件との整合性**
   - Issue の要件を満たしているか
4. **テストの十分性**
   - 変更に対するテストがあるか
5. **コードの可読性・保守性**
   - 命名、構造、コメント
6. **パフォーマンス**
   - 明らかな性能問題

## 6. レビュー結果を出力

結果を **日本語** で `.tmp/review_body.md` に保存:

```bash
mkdir -p .tmp
```

### 出力フォーマット

```markdown
# コードレビュー: PR #<PR_NUMBER>

**タイトル**: <PR_TITLE>
**レビュー日**: <DATE>
**レビュワー**: Codex CLI

## サマリー

[全体的な所見を1-2文で]

## 判定

- [ ] APPROVE: 問題なし、マージ可能
- [ ] REQUEST_CHANGES: 修正が必要
- [ ] COMMENT: 参考情報のみ

## 指摘事項

### [MUST] 必須対応

#### 1. [ファイル名:行番号] 指摘タイトル

**問題**: 問題の説明
**提案**: 修正案

### [SHOULD] 推奨対応

#### 1. [ファイル名:行番号] 指摘タイトル

**問題**: 問題の説明
**提案**: 修正案

### [COULD] 任意対応

#### 1. [ファイル名:行番号] 指摘タイトル

**問題**: 問題の説明
**提案**: 修正案

## 良かった点

- [良かった点があれば記載]
```

## 7. 完了報告

レビュー完了後、以下を報告:

- レビュー結果の保存先: `.tmp/review_body.md`
- 判定（APPROVE / REQUEST_CHANGES / COMMENT）
- 指摘数のサマリー

**注意**: このレビュー結果を PR に投稿するかどうかはユーザーの判断に委ねる。
