from __future__ import annotations

from pathlib import Path


def _parse_list(lines: list[str], start: int, indent: int) -> tuple[list[str], int]:
    items = []
    i = start
    while i < len(lines):
        raw = lines[i]
        if not raw.strip():
            i += 1
            continue
        current_indent = len(raw) - len(raw.lstrip(" "))
        if current_indent < indent:
            break
        line = raw.strip()
        if not line.startswith("- "):
            break
        items.append(line[2:].strip())
        i += 1
    return items, i


def load_config(path: Path) -> dict:
    if not path.exists():
        return {}

    lines = path.read_text(encoding="utf-8").splitlines()
    config: dict = {}
    i = 0
    while i < len(lines):
        raw = lines[i].rstrip()
        if not raw or raw.lstrip().startswith("#"):
            i += 1
            continue
        indent = len(raw) - len(raw.lstrip(" "))
        if indent != 0:
            i += 1
            continue
        key = raw.strip().rstrip(":")
        section = {}
        i += 1
        while i < len(lines):
            sub = lines[i]
            if not sub.strip():
                i += 1
                continue
            sub_indent = len(sub) - len(sub.lstrip(" "))
            if sub_indent <= indent:
                break
            stripped = sub.strip()
            if ":" not in stripped:
                i += 1
                continue
            if stripped.endswith(":"):
                sub_key = stripped.rstrip(":")
                list_items, next_i = _parse_list(lines, i + 1, sub_indent + 2)
                section[sub_key] = list_items
                i = next_i
                continue
            sub_key, value = stripped.split(":", 1)
            section[sub_key.strip()] = value.strip().strip('"').strip("'")
            i += 1
        config[key] = section
    return config
