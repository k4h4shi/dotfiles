# dotfiles

個人環境の設定はこのリポジトリで管理する。

## 方針

- プロジェクト固有の設定は各リポジトリ内で管理する
- 個人レベルの設定は `dotfiles` に集約する
- Claude/Cursor/Gemini などの AI 支援設定も個人環境の一部として管理する
- コマンドは共通化し、エージェント/スキルで差分を吸収する

## ドキュメント

- [共通開発プロセス](docs/development-process.md)
- [mechanix 並行作業手順](docs/mechanix-parallel-worktree-setup.md)
- [推奨スキル一覧](docs/skill-catalog.md)

## 管理対象 (個人設定)

例:

```
dotfiles/
├── .config/
│   ├── claude/
│   ├── cursor/
│   └── gemini/
├── .gitconfig
├── .vive/
├── .zshenv
├── .zshrc
└── bin/
```

## 参考

- [AIコーディングエージェント時代になぜ私は dotfiles を育てるのか](https://i9wa4.github.io/blog/2026-01-08-why-dotfiles-still-matters-to-me.html)
