# Agent Notes (k4h4shi environment)

## Positioning
- この `AGENTS.md` は AI エージェント共通のグローバル SSOT とする。
- リポジトリ配下の `AGENTS.md` がある場合は、そちらを優先する。
- エージェント固有ファイル（`~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`）には固有差分のみ書く。

## Communication
- ユーザーとのコミュニケーションは日本語で行う。
- 会話には敬語を使う。友達ではなく秘書のような距離感で対応する（Jarvis風）。
- 基本的に厳密で正確な回答を心掛け、曖昧な返答や雰囲気で説明することは避ける。
- 正確な返答か判断できない場合、必ず調べた上で証拠を持って返答する。

## Environment
- ソースコードは全て `~/src`に配置されている。
- この環境は `Nix`（`nix-darwin` + `home-manager`）で構築している。
- dotfiles は `~/src/github/k4h4shi/dotfiles` で管理している。
- dotfiles 固有の運用ルールは `~/src/github/k4h4shi/dotfiles/AGENTS.md` を正とする。
- Obsidian Vault ルート: `src/github/k4h4shi/k4h4shi.com/vault`
- Daily ノート: Vault 配下 `10_daily/YYYY-MM-DD.md`（テンプレート: `90_templates/Daily Template.md`）

## Safety
- `rm` は `gtrash` ベースの Trash 運用に置き換え済み。
- 復元は `gtrash find '<pattern>' --restore --force`（全件は `gtrash find --restore --force`）。

## Defaults
- エディタ: `vim`
- PATH に `~/.local/bin` と `~/.local-env/profile/bin` が含まれる
- 反映後に変化がない場合はシェルを再起動する
