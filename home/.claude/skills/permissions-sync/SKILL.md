---
name: permissions-sync
description: Permissions Sync (Global)
allowed-tools: Bash, Read
---

# Permissions Sync (Global)

Claude Code の実行ログ（`~/.claude/debug/*.txt`）を解析し、過去に「常に許可」したツール許可ルールを抽出して **グローバル設定（dotfiles 管理）**に反映します。

## ゴール

- **目的**: worktree / リポジトリを跨いでも許可待ちを減らす
- **正本**: `dotfiles/.config/claude/settings.json`（`~/.claude/settings.json` は symlink 前提）

## 手順

### 1. 事前確認

symlink の確認:
```bash
python3 - <<'PY'
import os
p=os.path.expanduser("~/.claude/settings.json")
print("islink", os.path.islink(p))
print("realpath", os.path.realpath(p))
PY
```

### 2. ログから許可ルールを抽出・フィルタ・反映

以下の Python スクリプトを実行してルールを抽出し、dotfiles に反映:

```bash
python3 - <<'PY'
import json, os, glob, re

DOTFILES=os.path.expanduser("~/src/github/k4h4shi/dotfiles")
TARGET=os.path.join(DOTFILES, ".config/claude/settings.json")

cfg=json.load(open(TARGET))
cfg.setdefault("permissions", {})
allow=set(cfg["permissions"].get("allow") or [])

debug_dir=os.path.expanduser("~/.claude/debug")
pat=re.compile(r"Adding\s+\d+\s+allow\s+rule\(s\)\s+to\s+destination\s+'[^']+':\s+(\[.*\])")

def is_good(rule: str) -> bool:
  if "\n" in rule or "\r" in rule:
    return False
  if "cat <<" in rule or "EOF" in rule:
    return False
  if "/.worktrees/" in rule:
    return False
  if rule.startswith("Bash(PORT=") or "PRISMA_USER_CONSENT" in rule:
    return False
  return True

new=set()
for fn in glob.glob(os.path.join(debug_dir, "*.txt")):
  with open(fn, "r", errors="ignore") as f:
    for line in f:
      m=pat.search(line)
      if not m:
        continue
      try:
        arr=json.loads(m.group(1))
      except Exception:
        continue
      for r in arr:
        if isinstance(r, str) and is_good(r):
          if r.startswith("Bash(") or r.startswith("Skill(") or r.startswith("WebFetch(") or r == "WebSearch":
            new.add(r)

added=sorted(new - allow)
cfg["permissions"]["allow"]=sorted(allow | new)

with open(TARGET, "w", encoding="utf-8") as f:
  json.dump(cfg, f, ensure_ascii=False, indent=2)
  f.write("\n")

print("updated:", TARGET)
print("added:", len(added))
for r in added[:50]:
  print("  +", r)
if len(added) > 50:
  print("  ...")
PY
```

### 3. 検証

```bash
python3 - <<'PY'
import json, os
TARGET=os.path.expanduser("~/src/github/k4h4shi/dotfiles/.config/claude/settings.json")
json.load(open(TARGET))
print("OK:", TARGET)
PY
```

### 4. 設定反映（任意）

必要なら dotfiles のインストールスクリプトを実行:

```bash
bash ~/src/github/k4h4shi/dotfiles/bin/install-ai-config.sh
```

## 運用メモ

- 今後は **このスキルでログ→設定の同期**を行う
- 「広すぎる」許可が混ざる場合は、フィルタ条件（`is_good`）を調整する
