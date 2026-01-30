---
name: subagent-coverage
description: コードカバレッジ実行と分析をCodexに委譲する。Usage: /subagent-coverage
allowed-tools: Bash
---

# サブエージェントカバレッジ（Codex委譲）

このスキルは、`codex` CLI 経由で外部のCodexエージェントにカバレッジ分析を委譲する。

## 原則（重要）

- コードカバレッジは **シグナル**。目的は **不足テスト観点の発見**（テストカバレッジ/テスト有効性の向上）。
- 数字を上げること自体を目的にしない。

参考: [コードカバレッジ vs. テストカバレッジ vs. テスト有効性](https://www.qt.io/ja-jp/blog/code-coverage-vs.-test-coverage-vs.-test-effectiveness-what-do-you-measure)

## 手順

1. **Codexを呼び出す**:

   ```bash
   codex exec -s workspace-write -c 'sandbox_permissions=["disk-full-read-access"]' \
     --output-last-message - \
     "/coverage"
   ```

2. **報告**:
   - Codexにカバレッジ分析を依頼したことをユーザーに伝える
   - 結果は標準出力で返る
