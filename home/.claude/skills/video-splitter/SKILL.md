---
name: video-splitter
description: Split video files into smaller chunks under a specified size limit (default 200MB). Use when users need to split large videos for upload limits, sharing, or storage constraints. Supports any video format that ffmpeg can handle. Requires ffmpeg installed.
---

# Video Splitter

Split large video files into chunks under a target file size.

## Requirements

- ffmpeg and ffprobe must be installed

## Usage

Run the split script:

```bash
python3 scripts/split_video.py <input_video> -s <max_size_mb> -o <output_dir>
```

### Arguments

- `input`: Input video file path (required)
- `-s, --max-size`: Maximum size per chunk in MB (default: 200)
- `-o, --output-dir`: Output directory (default: same as input)
- `-p, --prefix`: Output filename prefix (default: input filename)

### Example

```bash
# Split video into 200MB chunks
python3 scripts/split_video.py "/path/to/video.mp4" -s 200

# Split with custom output directory and prefix
python3 scripts/split_video.py "/path/to/video.mp4" -s 100 -o /output/dir -p "meeting"
```

## How It Works

1. Analyzes video to get duration and file size
2. Calculates optimal number of parts based on target size
3. Uses ffmpeg with stream copy (no re-encoding) for fast splitting
4. Names output files as `{prefix}_part01.mp4`, `{prefix}_part02.mp4`, etc.
