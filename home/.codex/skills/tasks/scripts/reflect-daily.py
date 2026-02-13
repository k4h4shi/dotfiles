#!/usr/bin/env python3
from __future__ import annotations

import os
import re
import subprocess
import sys
from datetime import date
from pathlib import Path

from config import load_config
from sources.utils import run_json, run_text


TASK_LINE_RE = re.compile(r"^- \[(.)\]\s+(.+?)\s+\[(tsks:[^\]]+)\]\s*$")
REASON_RE = re.compile(r"^\s+-\s+reason:\s*(.+)$")
IDENT_RE = re.compile(r"^tsks:([^:]+):([^/]+)/([^:]+):(.+)$")


def _daily_path(vault: Path, date_str: str | None) -> Path:
    override = os.environ.get("OBS_DAILY_DIR", "").strip()
    target = date_str or date.today().isoformat()
    if override:
        return Path(override) / f"{target}.md"
    return vault / "10_daily" / f"{target}.md"


def _read_reason_from_file(path: Path, line_no: int) -> str | None:
    lines = path.read_text(encoding="utf-8").splitlines()
    idx = line_no - 1
    if idx < 0 or idx >= len(lines):
        return None
    for offset in range(1, 6):
        if idx + offset >= len(lines):
            break
        raw = lines[idx + offset]
        if raw.startswith("- [") or raw.startswith("## "):
            break
        match = REASON_RE.match(raw)
        if match:
            return match.group(1).strip()
    return None


def _read_tasks(daily_path: Path, vault: Path, date_str: str | None) -> list[dict]:
    if not daily_path.exists():
        raise SystemExit(f"daily not found: {daily_path}")

    try:
        if date_str:
            output = run_text(
                ["obsidian", "tasks", f"file={daily_path.relative_to(vault).as_posix()}", "verbose"]
            )
        else:
            output = run_text(["obsidian", "tasks", "daily", "verbose"])
    except subprocess.CalledProcessError as exc:
        raise SystemExit(f"obsidian tasks failed: {exc}") from exc

    if not output.strip():
        return []

    lines = output.splitlines()
    tasks = []
    current_file = None
    for raw in lines:
        if raw.endswith(".md") and "\t" not in raw:
            current_file = raw.strip()
            continue
        if "\t" not in raw or current_file is None:
            continue
        line_no_str, content = raw.split("\t", 1)
        try:
            line_no = int(line_no_str)
        except ValueError:
            continue
        match = TASK_LINE_RE.match(content)
        if not match:
            continue
        status, title, ident = match.groups()
        reason = _read_reason_from_file(vault / current_file, line_no)
        tasks.append(
            {
                "status": status,
                "title": title,
                "identity": ident,
                "reason": reason,
            }
        )
    return tasks


def _parse_identity(identity: str) -> tuple[str, str, str, str]:
    match = IDENT_RE.match(identity)
    if not match:
        raise ValueError(f"invalid identity: {identity}")
    return match.group(1), match.group(2), match.group(3), match.group(4)


def _is_pr(org: str, repo: str, number: str) -> bool:
    try:
        run_json(["gh", "api", f"repos/{org}/{repo}/pulls/{number}"])
        return True
    except subprocess.CalledProcessError:
        return False


def _gh_close(org: str, repo: str, number: str, reason: str | None) -> None:
    if _is_pr(org, repo, number):
        if reason:
            subprocess.run(
                ["gh", "pr", "comment", number, "--repo", f"{org}/{repo}", "--body", reason],
                check=True,
            )
        subprocess.run(["gh", "pr", "close", number, "--repo", f"{org}/{repo}"], check=True)
        return
    if reason:
        subprocess.run(
            ["gh", "issue", "comment", number, "--repo", f"{org}/{repo}", "--body", reason],
            check=True,
        )
    subprocess.run(["gh", "issue", "close", number, "--repo", f"{org}/{repo}"], check=True)


def _jira_close(key: str, reason: str | None, done_status: str | None) -> None:
    status = (done_status or "").strip() or os.environ.get("JIRA_DONE_STATUS", "").strip()
    candidates = [status] if status else ["Done", "完了"]
    last_error = None
    for candidate in candidates:
        cmd = ["jira", "issue", "move", key, candidate]
        if reason:
            cmd += ["--comment", reason]
        try:
            subprocess.run(cmd, check=True)
            return
        except subprocess.CalledProcessError as exc:
            last_error = exc
    if last_error:
        raise last_error


def _obsidian_close(vault: Path, task_id: str, canceled: bool) -> None:
    tasks_dir = vault / "15_tasks"
    if not tasks_dir.exists():
        raise SystemExit("obsidian tasks dir not found")
    status = "canceled" if canceled else "done"

    for path in tasks_dir.rglob("*.md"):
        text = path.read_text(encoding="utf-8")
        if f"task_id: {task_id}" not in text:
            continue
        lines = text.splitlines()
        if not lines or lines[0].strip() != "---":
            raise SystemExit(f"frontmatter not found: {path}")
        updated = []
        in_front = True
        status_set = False
        for line in lines[1:]:
            if in_front and line.strip() == "---":
                if not status_set:
                    updated.append(f"task_status: {status}")
                updated.append(line)
                in_front = False
                continue
            if in_front and line.startswith("task_status:"):
                updated.append(f"task_status: {status}")
                status_set = True
                continue
            updated.append(line)
        if in_front and not status_set:
            updated.append(f"task_status: {status}")
        output = [lines[0]] + updated
        path.write_text("\n".join(output) + "\n", encoding="utf-8")
        return
    raise SystemExit(f"task_id not found: {task_id}")


def main() -> int:
    home = Path.home()
    vault = Path(os.environ.get("OBS_VAULT", home / "src/github/k4h4shi/k4h4shi.com/vault"))
    config_path = Path(
        os.environ.get("TSKS_CONFIG", home / ".config/local-env/tsks/config.yaml")
    )
    config = load_config(config_path)
    jira_cfg = config.get("jira", {})
    jira_done_status = jira_cfg.get("done_status") if isinstance(jira_cfg, dict) else None
    date_str = None
    if len(sys.argv) > 1:
        date_str = sys.argv[1]
    daily_path = _daily_path(vault, date_str)
    tasks = _read_tasks(daily_path, vault, date_str)

    errors = []
    for task in tasks:
        status = task["status"]
        if status not in {"x", "-"}:
            continue
        identity = task["identity"]
        reason = task.get("reason")
        try:
            source, org, proj, key = _parse_identity(identity)
            if source == "github":
                _gh_close(org, proj, key, reason if status == "-" else None)
            elif source == "jira":
                _jira_close(key, reason if status == "-" else None, jira_done_status)
            elif source == "obsidian":
                _obsidian_close(vault, key, canceled=(status == "-"))
        except Exception as exc:
            errors.append((identity, str(exc)))

    if errors:
        for ident, err in errors:
            print(f"error: {ident}: {err}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
