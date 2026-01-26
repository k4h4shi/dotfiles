---
description: "公式ベストプラクティス（Claude Code / OpenAI Codex / Gemini CLI）に基づいて dotfiles のAI関連設定を監査し、アンチパターンを検出して必要なら最小修正まで行う。Usage: /best-practices-review"
---

# dotfiles ベストプラクティス監査（Claude Code / Codex / Gemini）

目的: 公式のベストプラクティスと安全指針（Claude Code / OpenAI Codex / Gemini CLI）を根拠に、dotfiles 配下の **AI関連設定**を監査し、アンチパターンを避ける形に整える（必要なら最小修正まで行う）。

## 公式リンク（根拠）

### Anthropic — Claude Code

- [`Claude Code: Best practices for agentic coding`](https://www.anthropic.com/engineering/claude-code-best-practices)
- [`Claude Code settings`](https://docs.anthropic.com/en/docs/claude-code/settings)
- [`Claude Code security`](https://docs.anthropic.com/en/docs/claude-code/security)

### OpenAI — Codex / Codex CLI

- [`Introducing Codex`](https://openai.com/index/introducing-codex/)
- [`Codex CLI reference`](https://developers.openai.com/codex/cli/reference/)
- [`Custom instructions with AGENTS.md`](https://developers.openai.com/codex/guides/agents-md)
- [`Codex security`](https://developers.openai.com/codex/security)

### Google — Gemini CLI

- [`Gemini CLI configuration`](https://geminicli.com/docs/get-started/configuration-v1/)
- [`Gemini CLI settings`](https://geminicli.com/docs/cli/settings/)
- [`Sandboxing in the Gemini CLI`](https://geminicli.com/docs/cli/sandbox)
- [`Trusted Folders`](https://google-gemini.github.io/gemini-cli/docs/cli/trusted-folders.html)

### 補足（共通フォーマット）

- [`AGENTS.md (Open Format for Coding Agents)`](https://agents.md/)

## 対象（dotfiles）

- `home/.claude/**`（commands / agents / skills / settings / `CLAUDE.md`）
- `home/.codex/**`（`instructions.md` / skills）
- `home/.cursor/**`（commands / rules）
- `home/.gemini/**`
- `home/.vive/**`
- `modules/home.nix`（配布パスの整合）

## 観点（アンチパターン検出 → 必要なら最小修正）

### 1) Trust-then-verify gap（検証なしで終える）

- 変更作業に **検証手段**（テスト/ビルド/リンタ/期待出力/スクショ）が必ず紐づいているか
- “それっぽい修正”で終える導線（例: 「修正して終わり」）になっていないか

### 2) Kitchen sink session（1セッションに詰め込みすぎ）

- `/fix` のような入口が「実装→PR→CI→レビュー→retro」まで一気通貫で長大になっていないか
- 長い手順は **別スキルへ切り出し**できているか（例: post-PR ワークフロー、retro 等）

### 3) Infinite exploration（無制限探索でコンテキストを溶かす）

- “調査”の粒度が大きすぎないか（無制限に読む前提になっていないか）
- 大規模調査は **分割**（問いを小さくする）または **サブエージェント委譲**で制御できるか

### 4) Over-specified memory（常時読み込みが長すぎる）

- `~/.claude/CLAUDE.md` / `~/.codex/instructions.md` が長すぎないか
- 「毎回必要」な内容だけに絞れているか（詳細手順は skills へ）

### 5) Permissions / Sandbox（許可待ち削減のための危険設定）

- **Claude Code**: allowlist が広すぎないか（例: 実質フルシェル許可になっていないか）
- **Codex CLI**: `--dangerously-bypass-approvals-and-sandbox` のような危険フラグが常用されていないか
- **Gemini CLI**: Trusted Folders / sandbox の考え方に反して、無制限な実行がデフォルトになっていないか

## このdotfilesで実際に検出した問題（修正済み）

### Vive（Codex起動コマンド）

- **該当**: `home/.vive/config.toml`
- **問題**: `issue_command` が `--dangerously-bypass-approvals-and-sandbox` になっており、公式の安全推奨（sandbox/approval）と逆
- **修正**: `--sandbox workspace-write` を使う形に変更済み

### Claude Code（権限allowlist）

- **該当**: `home/.claude/settings.json`
- **問題**: `Bash(/bin/bash *)` / `Bash(bash *)` があると、パターン上 **実質フルシェル許可**になりやすい
- **修正**: 上記2行を削除済み（最小の権限絞り込み）

## 実施手順

1. **差分/現状確認**:
   - `git status -sb`
   - `git diff`
2. **対象ファイルを読む**（まず読む、いきなり修正しない）:
   - `home/.claude/CLAUDE.md` / `home/.claude/settings.json`
   - `home/.claude/commands/*` / `home/.claude/skills/*/SKILL.md`
   - `home/.codex/instructions.md` / `home/.codex/skills/*/SKILL.md`
   - `home/.gemini/**`（commands / settings があれば）
   - `home/.vive/config.toml`
3. **アンチパターン診断**（観点1〜5）:
   - 観点ごとに「該当箇所」「理由（公式根拠）」「改善案（最小変更）」を列挙
4. **最小修正（必要な場合のみ実施）**:
   - “分離/短縮/参照化/安全側のデフォルト” を優先（大量リライトは避ける）
   - 変更後に `git diff` を再確認し、目的に合うことを説明する

## 出力フォーマット

```markdown
## dotfiles Best Practices Review

参照:
- https://www.anthropic.com/engineering/claude-code-best-practices
- https://developers.openai.com/codex/cli/reference/
- https://geminicli.com/docs/cli/sandbox

### Summary
- 対象: [...]
- 重大度: [high/medium/low]

### Findings
#### 1) Trust-then-verify gap
- 該当: <path>:<section>
- 問題: ...
- 修正案: ...

#### 2) Kitchen sink session
...

#### 3) Infinite exploration
...

#### 4) Over-specified memory
...

#### 5) Permissions / Sandbox
...

### Proposed minimal changes
- [ ] ...
```

