# dotfiles

個人環境の設定はこのリポジトリで管理する。

## インストール

```bash
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
./install.sh
```

## 方針

- プロジェクト固有の設定は各リポジトリ内で管理する
- 個人レベルの設定は `dotfiles` に集約する
- Claude/Cursor/Gemini などの AI 支援設定も個人環境の一部として管理する
- コマンドは共通化し、エージェント/スキルで差分を吸収する

## ドキュメント

- [共通開発プロセス](docs/development-process.md)
- [推奨スキル一覧](docs/skill-catalog.md)

## 構成

```
dotfiles/
├── .claude/          # このリポジトリ用（展開しない）
├── home/             # ~ に展開
│   ├── .claude/
│   ├── .codex/
│   ├── .cursor/
│   ├── .gemini/
│   ├── .gitconfig
│   ├── .vive/
│   ├── .zshenv
│   └── .zshrc
├── docs/
├── install.sh
└── README.md
```

## 参考

- [AIコーディングエージェント時代になぜ私は dotfiles を育てるのか](https://i9wa4.github.io/blog/2026-01-08-why-dotfiles-still-matters-to-me.html)
