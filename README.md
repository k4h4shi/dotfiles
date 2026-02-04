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

### Cursor 設定

以下が管理されています：

- `settings.json` - エディタ設定
- `keybindings.json` - キーバインド
- `extensions.json` - 推奨拡張機能リスト（17個）
- `.cursor/commands/` - カスタムコマンド
- `.cursor/rules/` - プロジェクトルール

#### 推奨拡張機能（カテゴリ別）

- **AI**: Claude Code, ChatGPT
- **Web開発**: Biome, Tailwind, ESLint, Prettier, Prisma, Jest, Playwright
- **Git/GitHub**: GitHub Actions, PR管理, Worktree
- **データベース**: PostgreSQL
- **Markdown**: Mermaid, Preview Enhanced, PDF出力
- **インフラ**: Docker

## 更新

```bash
./apply.sh personal  # または common
```

### apply.sh が必要になるタイミング

- `modules/home.nix` / `modules/darwin.nix` / `flake.nix` を変更したとき
- `home.file` に新しいファイルを追加・削除したとき
- シンボリックリンクの張り替えが必要なとき

### apply.sh が不要なタイミング

- 既存のリンク先ファイルの中身を編集しただけのとき
  - 例: `home/.zshrc`、`home/Library/Application Support/Cursor/User/settings.json`

## 参考

- [Nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [home-manager](https://github.com/nix-community/home-manager)
