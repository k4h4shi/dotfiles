# dotfiles

Nix + home-manager で管理する個人環境。

## インストール

```bash
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
./install.sh
```

初回実行時にNixがインストールされる。シェルを再起動後、再度 `./install.sh` を実行。

## 構成

```
dotfiles/
├── .claude/          # このリポジトリ用（展開しない）
├── flake.nix         # Nixエントリーポイント
├── flake.lock
├── modules/
│   └── home.nix      # home-manager設定
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

### Nixで管理（パッケージ + 設定）

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
nix run home-manager -- switch --flake .#takahashikotaro
```

## 開発

このリポジトリを編集する際:

```bash
nix develop  # または direnv allow
```

Nix LSP（nil）とフォーマッタ（nixpkgs-fmt）が使える。

## 新しいマシンで使う場合

1. リポジトリをクローン
2. `./install.sh` 実行（Nixがインストールされる）
3. シェル再起動
4. `./install.sh` 再実行（home-managerが適用される）

## 方針

- 宣言的に環境を管理（Nix）
- AI支援ツールの設定は `home/` に集約
- プロジェクト固有の設定は各リポジトリで管理

## 参考

- [Nix](https://nixos.org/)
- [home-manager](https://github.com/nix-community/home-manager)
