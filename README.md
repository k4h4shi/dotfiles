# dotfiles

Nix + nix-darwin + home-manager で管理する個人環境。

## インストール

```bash
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
./install.sh           # personal（デフォルト）
./install.sh common    # common
```

初回は Nix がインストールされる。シェル再起動後、再度実行。

## プロファイル

| プロファイル | 内容 |
|--------------|------|
| `personal` | 共通 + 音楽制作アプリ |
| `common` | 共通アプリのみ |

## 構成

```
dotfiles/
├── flake.nix           # エントリーポイント
├── modules/
│   ├── darwin.nix      # macOS設定 + Homebrew Cask
│   └── home.nix        # CLIツール + シェル設定
├── home/               # AI設定ファイル
│   ├── .claude/
│   ├── .codex/
│   ├── .cursor/
│   ├── .gemini/
│   └── .vive/
└── install.sh
```

## 管理対象

| レイヤー | 内容 |
|----------|------|
| nix-darwin | GUIアプリ、Dock/Finder設定、キーボード、Touch ID sudo |
| home-manager | Git, Zsh, 開発ツール, 言語ランタイム, direnv, starship |
| home/ | Claude, Cursor, Gemini, Codex, Vive の設定ファイル |

## 更新

```bash
./install.sh personal  # または common
```

## 参考

- [Nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
