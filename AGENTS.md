# dotfiles Agent Notes

このファイルは `~/src/github/k4h4shi/dotfiles` リポジトリ専用の運用ルール。

## Scope
- 対象リポジトリ: `~/src/github/k4h4shi/dotfiles`

## Managed / Unmanaged
- 管理対象:
  - `modules/darwin.nix`: macOS設定 + Homebrew Cask
  - `modules/home.nix`: CLIツール、Zsh、言語ランタイム、開発ツール
  - `home/`: AI関連ツール設定（Claude/Cursor/Codex/Gemini/Vive など）
- 管理しないもの:
  - マシン固有のパッケージは **dotfilesでは管理しない**
  - `~/.config/local-env/` に置き、別フローで反映する

## Apply Flow
指示は **必ず `dot` コマンド** で案内する。`./apply.sh` 等の直接実行は促さない。

```bash
dot apply
dot apply -m
dot apply -d
```

- `dot apply` を使うケース:
  - `modules/home.nix` / `modules/darwin.nix` / `flake.nix` を変更したとき
  - `home/` 配下にファイルを追加/削除したとき

### マシンローカルのパッケージ（dotfiles非管理）
```bash
cd ~/.config/local-env
direnv allow

vim ~/.config/local-env/flake.nix

dot apply -m
```

## dot CLI
```bash
dot add <query>     # shared（modules/home.nix / modules/darwin.nix）
dot add -m <query>  # machine（~/.config/local-env/flake.nix）
dot add -d <query>  # dir（カレントの flake.nix）

dot apply
dot apply -m
dot apply -d
```

ショートカット:
- `dot go` で `~/src/github/k4h4shi/dotfiles` に移動
