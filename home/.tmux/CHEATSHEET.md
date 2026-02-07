# tmux Cheat Sheet

`~/.tmux.conf` の現在設定と、tmux標準の早見表。

## 前提

- Prefix は `C-s`。
- `prefix + C-s` は pane に生の `C-s` を送る。
- マウス有効。
- Copy は `pbcopy` 連携。
- ステータスバーのウィンドウ名は 10 文字で切り詰め。

## 現在有効（この設定）

| カテゴリ | 操作 | キー |
|---|---|---|
| 基本 | Prefixに入る | `C-s` |
| 画面 | チートシート popup | `prefix + /` |
| 画面 | 設定リロード | `prefix + r` / `prefix + C-r` |
| ペイン | 移動 | `prefix + h/j/k/l` |
| ペイン | リサイズ | `prefix + H/J/K/L` |
| ペイン | 分割（左右） | `prefix + \|` / `prefix + %` |
| ペイン | 分割（上下） | `prefix + -` / `prefix + "` |
| ペイン | 閉じる（確認なし） | `prefix + q` |
| ペイン | 番号表示 | `prefix + Q` |
| ウィンドウ | 一覧表示（activity付き） | `prefix + w` |
| ウィンドウ | 直前ウィンドウに戻る | `prefix + ;` |
| ウィンドウ | 操作メニュー | `prefix + g` |
| ウィンドウ | 左へ移動 | `prefix + <` |
| ウィンドウ | 右へ移動 | `prefix + >` |
| クライアント | 次へ | `prefix + N` |
| クライアント | 前へ | `prefix + P` |
| 監視 | silence monitor 60s 切替 | `prefix + M` |
| 補助 | splitして `dot apply` | `prefix + a` |
| 補助 | prefixキー一覧 | `prefix + ?` |

## Copy Mode（この設定）

| モード | 操作 | キー |
|---|---|---|
| `copy-mode-vi` | コピーして終了 | `y` / `Enter` |
| `copy-mode-vi` | 終了 | `Escape` |
| `copy-mode` | コピーして終了 | `y` / `Enter` |
| `copy-mode` | 終了 | `Escape` |

## tmux標準（候補）

| カテゴリ | 操作 | 標準キー |
|---|---|---|
| セッション | デタッチ | `prefix + d` |
| セッション | セッション一覧 | `prefix + s` |
| セッション | セッション名変更 | `prefix + $` |
| ウィンドウ | 新規ウィンドウ | `prefix + c` |
| ウィンドウ | 次のウィンドウ | `prefix + n` |
| ウィンドウ | 前のウィンドウ | `prefix + p` |
| ウィンドウ | 番号ジャンプ | `prefix + 0..9` |
| ウィンドウ | ウィンドウ名変更 | `prefix + ,` |
| ウィンドウ | ウィンドウ削除（確認あり） | `prefix + &` |
| ペイン | copy-modeに入る | `prefix + [` |
| ペイン | ペイン削除（確認あり） | `prefix + x` |
| ペイン | ペイン最大化/解除 | `prefix + z` |
| ペイン | 次のペインへ移動 | `prefix + o` |
| ペイン | ペインを左右入れ替え | `prefix + {` / `prefix + }` |
| ペイン | ペインを新規ウィンドウ化 | `prefix + !` |

## ステータスバー

- 位置: 上 (`status-position top`)
- 更新間隔: 5秒 (`status-interval 5`)
- 自動リネーム: 無効 (`allow-rename off`, `automatic-rename off`)
- ペイン上部表示: `#P: #{pane_current_command} — #{pane_current_path}`
