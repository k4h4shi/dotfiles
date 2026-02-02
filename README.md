# dotfiles

Nix + nix-darwin + home-manager で管理する個人環境。

## インストール

```bash
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
./install.sh           # 個人用（デフォルト）
# または
./install.sh common    # 共通のみ（案件PC向け）
```

初回実行時に Nix と Homebrew がインストールされる。シェルを再起動後、再度 `./install.sh` を実行。

## プロファイル

| プロファイル | 用途 | アプリ |
|--------------|------|--------|
| `personal` | 自宅PC（デフォルト） | 共通 + 音楽制作 |
| `common` | 案件PC | 共通のみ |

### 共通アプリ（common）
- **開発**: docker, docker-desktop, ghostty, ngrok, cursor, google-chrome, anaconda
- **AI**: chatgpt, claude
- **ブラウザ**: arc
- **ユーティリティ**: 1password, alfred, cmd-eikana, scroll-reverser, displaylink, obsidian
- **コミュニケーション**: slack, spotify, zoom, line, readdle-spark

### 個人用追加アプリ（personal のみ）
- **音楽制作**: ableton-live-suite, izotope-product-portal, native-access, splice, background-music, waves-central, ilok-license-manager, sonic-visualiser
- **その他**: kindle

### 手動インストールが必要なアプリ
- **共通**: Xcode (App Store), Clean
- **個人用**: Logic Pro X (App Store), Spitfire Audio, Muse Hub, XLN Online Installer, Output Hub, inMusic Software Center, Arcade, SoundID Reference, iZotope Audiolens/Ozone 9, MOTU系, MPC, Neuro Desktop, SIGMA_PhotoPro6

## 構成

```
dotfiles/
├── flake.nix         # Nixエントリーポイント
├── flake.lock
├── modules/
│   ├── darwin.nix    # macOS設定（nix-darwin）
│   └── home.nix      # ユーザー設定（home-manager）
├── home/             # AI設定ファイル（Nixから参照）
│   ├── .claude/
│   ├── .codex/
│   ├── .cursor/
│   ├── .gemini/
│   └── .vive/
├── install.sh
└── README.md
```

## 管理対象

### nix-darwin で管理（macOS システム設定）

- Homebrew Cask（GUIアプリ）
- Dock / Finder 設定
- キーボード設定
- トラックパッド設定
- Touch ID で sudo

### home-manager で管理（ユーザー設定）

- Git（設定含む）
- Zsh（エイリアス、PATH設定含む）
- 開発ツール（gh, jq, ripgrep, fzf, tmux, etc.）
- 言語ランタイム（Node.js, Rust, Python, Ruby）
- direnv（プロジェクトごとの環境自動切り替え）
- starship（モダンなプロンプト）

### ファイルで管理（home/）

- Claude Code（agents, commands, skills, settings.json）
- Cursor（commands, rules）
- Gemini CLI（commands）
- Codex CLI（skills）
- Vive（config.toml, favorites.toml）

## 手動更新

設定を変更した後:

```bash
cd dotfiles

# macOS
nix run nix-darwin -- switch --flake ".#personal" --impure  # または common

# Linux
nix run home-manager -- switch --flake ".#${USER}" --impure -b backup
```

`--impure` フラグは環境変数（`USER`, `HOME`）を読み取るために必要。

## 開発

このリポジトリを編集する際:

```bash
nix develop  # または direnv allow
```

Nix LSP（nil）とフォーマッタ（nixpkgs-fmt）が使える。

## 新しいマシンで使う場合

1. リポジトリをクローン
2. `./install.sh common` 実行（案件PCの場合）
3. シェル再起動
4. `./install.sh common` 再実行

ユーザー名やホームディレクトリは環境変数から自動取得されるため、異なるユーザー名のマシンでもそのまま動作する。

## 方針

- 宣言的に環境を管理（Nix）
- AI支援ツールの設定は `home/` に集約
- プロジェクト固有の設定は各リポジトリで管理

## AIレビュー運用

Claude/Codex/Gemini によるコードレビューは **ローカル実行** を基本とする。

### 使い方

```bash
# Codex（デフォルト）
codex "/review <PR_NUMBER>"

# 実装（TDDフローの入口）
codex "/fix <ISSUE_NUMBER>"

# Gemini
gemini "/review <PR_NUMBER>"

# Claude 経由（サブエージェントにCodexを呼ぶ）
claude "/review <PR_NUMBER>"
```

### 出力

- レビュー結果は `.tmp/review_body.md` に保存
- PR への自動投稿は行わない（CIを無駄に走らせない）
- 必要なら手動で `gh pr review` を使って投稿

### Codex の共通設定

- `~/.codex/instructions.md`: 返答言語（日本語）や、dotfiles配布のカスタムskills一覧を記載
- `~/.codex/skills/custom/*`: dotfilesが配布するカスタムskills（`/fix`, `/issue`, `/planner`, `/tdd-runner` など）

## 参考

- [Nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
