# dotfiles

Nix + nix-darwin + home-manager で管理する個人環境。

## インストール

```bash
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
./install.sh           # common（デフォルト）
./install.sh personal  # personal（プライベートアプリ追加）
```

初回は Nix がインストールされる。シェル再起動後、再度実行。

## プロファイル

| プロファイル | 内容 |
|--------------|------|
| `personal` | 共通 + プライベートアプリ |
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
├── apply.sh            # 反映用（再適用）
└── install.sh          # 初期環境構築用
```

## 管理対象

| レイヤー | 内容 |
|----------|------|
| nix-darwin | GUIアプリ、Dock/Finder設定、キーボード、Touch ID sudo |
| home-manager | Git, Zsh, 開発ツール, 言語ランタイム, direnv, starship |
| home/ | Claude, Cursor, Gemini, Codex, Vive の設定ファイル |

## machine設定(dotfiles非管理設定)

dotfilesに入れたくないパッケージなどは `~/.config/local-env/` で管理する。
インストール時に `flake.nix` と `.envrc` は自動生成される（既存があれば上書きしない）。
反映は `~/.local-env/profile` に出すため、どのディレクトリでも使える。

```bash
# 初回のみ（direnvの許可）
cd ~/.config/local-env
direnv allow

# 端末ローカルのパッケージ追加
vim ~/.config/local-env/flake.nix

# 反映（どこでも使えるPATHに入る）
dot apply -m
```

### 使い分けの指針

- **shared**: `modules/home.nix` / `modules/darwin.nix`
- **machine**: `~/.config/local-env/flake.nix`

## dot（環境管理CLI）

3つのスコープを共通インターフェースで操作するためのCLI。

| スコープ | 意味 | 対象 |
|---------|------|------|
| shared | `dot add <query>` | `modules/home.nix` / `modules/darwin.nix` |
| machine | `dot add -m <query>` | `~/.config/local-env/flake.nix` |
| dir | `dot add -d <query>` | カレントの `flake.nix` |

### 使い方（短いインターフェース）

```bash
# 曖昧検索 → 候補提示 → 選択
dot add jira
dot add -m notion
dot add -d volta

# 反映
dot apply
dot apply -m
dot apply -d
```

### 補足

- shared は `home.nix` / `darwin.nix` に追記されるため、`apply` が必要。
- machine は `dot apply -m` で反映（profile更新）。
- dir は `direnv allow` 後、`direnv reload` で反映。

## 更新

```bash
./apply.sh personal  # または common

# home/ 配下の追加・削除だけ反映したい場合（軽量）
./apply-home.sh
```

### apply.sh が必要になるタイミング

- `modules/home.nix` / `modules/darwin.nix` / `flake.nix` を変更したとき
- `home/` 配下に新しいファイルを追加・削除したとき（Home Manager が symlink を張り替えるため）
- シンボリックリンクの張り替えが必要なとき

補足:

- `home/.config/local-env/` は端末ローカルで育てる領域なので、ディレクトリ自体は管理しません（テンプレのみを展開）。

### apply.sh が不要なタイミング

- 既存のリンク先ファイルの中身を編集しただけのとき
  - 例: `home/.zshrc`、`home/Library/Application Support/Cursor/User/settings.json`

### apply-home.sh が向いているタイミング

- `home/` 配下のファイル追加・削除のみ（nix-darwin 設定は触っていない）

## 参考

- [Nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
