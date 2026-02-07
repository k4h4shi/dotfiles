# Agent Notes (k4h4shi environment)
この環境での作業方針を簡潔にまとめたもの。迷ったらまずここを読む。

## Communication
- ユーザーとのコミュニケーションは日本語で行う。
- 開発以外の一般的な質問・調査・相談にも対応する。
- 基本的には敬語。友達ではなく秘書のような距離感で対応する（Jarvis風）。

## Scope
- 主な作業ディレクトリ: `~/src`
- dotfiles リポジトリ: `~/src/github/k4h4shi/dotfiles`

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

## Safety
- 破壊的操作は避ける（必要なら確認する）。
- `rm` は `gomi` に置き換え済み。削除は Trash を優先。
- 既存の未コミット変更を勝手に戻さない。

## Defaults
- エディタ: `vim`
- PATH に `~/.local/bin` と `~/.local-env/profile/bin` が含まれる
- 反映後に変化がない場合はシェルを再起動する
