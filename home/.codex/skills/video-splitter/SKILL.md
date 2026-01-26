---
name: video-splitter
description: "動画ファイルを指定サイズ以下（デフォルト200MB）に分割する。Usage: /video-splitter"
---

# 動画分割（Video Splitter）

大きい動画ファイルを、指定したサイズ以下のチャンクに分割する。

## 必要要件

- ffmpeg / ffprobe がインストールされていること

## 使い方

分割スクリプトを実行する:

```bash
python3 scripts/split_video.py <input_video> -s <max_size_mb> -o <output_dir>
```

### 引数

- `input`: 入力動画ファイルパス（必須）
- `-s, --max-size`: 1分割あたりの最大サイズ（MB、デフォルト: 200）
- `-o, --output-dir`: 出力ディレクトリ（デフォルト: 入力と同じ場所）
- `-p, --prefix`: 出力ファイル名プレフィックス（デフォルト: 入力ファイル名）

### 例

```bash
# 200MBごとに分割
python3 scripts/split_video.py "/path/to/video.mp4" -s 200

# 出力先とプレフィックスを指定して分割
python3 scripts/split_video.py "/path/to/video.mp4" -s 100 -o /output/dir -p "meeting"
```

