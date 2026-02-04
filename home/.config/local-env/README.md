# Machine-Local Environment

この端末だけにインストールしたいパッケージを管理するディレクトリです。
dotfilesでは管理されません。

## セットアップ

```bash
# テンプレートをコピー
cp flake.nix.template flake.nix

# .envrc を作成
echo "use flake" > .envrc

# direnv を有効化
direnv allow
```

## 使い方

1. `flake.nix` の `packages` にパッケージを追加
2. `cd ~/.config/local-env` で環境が自動的に有効化

## dotfiles との違い

| 場所 | 範囲 | 用途 |
|------|------|------|
| `dotfiles/modules/home.nix` | 全端末共通 | git, ripgrep など |
| `dotfiles/modules/darwin.nix` | 全端末共通 | Cursor, Slack など |
| `~/.config/local-env/flake.nix` | この端末だけ | 業務固有、一時的なもの |
