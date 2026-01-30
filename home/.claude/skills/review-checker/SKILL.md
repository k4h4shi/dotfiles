---
name: review-checker
description: PRの新しいレビュー/コメントを監視し、要点＋抜粋だけ返すためのスクリプト置き場。review-checker subagent が実行する。
---

# Review Checker（スキル: スクリプト＋運用ルール）

このスキルは **「PRレビューコメント監視」をスクリプト化**するための置き場所。
実行は `review-checker` subagent が行い、メインには **要点＋抜粋**だけ返す。

## 実行（subagent 内で）

```bash
bash ~/.claude/skills/review-checker/scripts/watch-pr-reviews.sh
```

### 挙動（重要）

- 起動時に **未解決スレッド / Changes requested** が既にある場合は、それを検知して **即座に取得結果を返して終了**する
- 何もなければ、起動時刻以降の **新規** を最大 \(interval \times max\) 秒だけ監視し、見つけた瞬間に返す

### オプション

```bash
# PR番号を明示
bash ~/.claude/skills/review-checker/scripts/watch-pr-reviews.sh --pr 123

# ポーリング間隔と最大回数（擬似watch）
bash ~/.claude/skills/review-checker/scripts/watch-pr-reviews.sh --interval 30 --max 30

# 既存指摘を無視して「新規だけ」を監視（旧挙動）
bash ~/.claude/skills/review-checker/scripts/watch-pr-reviews.sh --only-new
```

