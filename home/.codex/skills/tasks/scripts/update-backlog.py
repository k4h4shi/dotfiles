#!/usr/bin/env python3
import os
import re
import shutil
from datetime import date
from pathlib import Path

from config import load_config
from sources.github import collect_github_items
from sources.jira import collect_jira_items
from sources.obsidian import collect_obsidian_items


def have(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def load_backlog(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def update_front_matter(text: str) -> str:
    if not text.startswith("---"):
        return text
    parts = text.split("---", 2)
    if len(parts) < 3:
        return text
    front = parts[1].splitlines()
    updated = False
    for i, line in enumerate(front):
        if line.strip().startswith("modified:"):
            front[i] = f"modified: {date.today().isoformat()}"
            updated = True
            break
    if not updated:
        front.append(f"modified: {date.today().isoformat()}")
    parts[1] = "\n".join(front) + "\n"
    return "---".join(parts)


def _normalize_project_tag(value: str) -> str:
    normalized = value.strip().lower().replace("_", "-")
    normalized = normalized.replace(" ", "-")
    normalized = re.sub(r"[^\w-]+", "-", normalized, flags=re.UNICODE)
    normalized = re.sub(r"-{2,}", "-", normalized)
    return normalized.strip("-")


def _project_tag_for_item(system: str, proj: str) -> str | None:
    tag = None
    if system == "github":
        tag = _normalize_project_tag(proj)
    elif system == "jira":
        tag = _normalize_project_tag(proj)
    if not tag:
        return None
    return f"#project/{tag}"


def format_task_line(
    status: str,
    system: str,
    org: str,
    proj: str,
    key: str,
    title: str,
    project_tag: str | None = None,
) -> str:
    ident = f"tsks:{system}:{org}/{proj}:{key}"
    if system == "github":
        url = f"https://github.com/{org}/{proj}/issues/{key}"
        title = f"[{title}]({url})"
    elif system == "jira":
        url = f"https://{org}.atlassian.net/browse/{key}"
        title = f"[{title}]({url})"
    parts = [f"- [{status}] {title}"]
    if project_tag:
        parts.append(project_tag)
    parts.append(f"[{ident}]")
    return " ".join(parts)


def _daily_path(vault: Path) -> Path:
    override = os.environ.get("OBS_DAILY_DIR", "").strip()
    target = date.today().isoformat()
    if override:
        return Path(override) / f"{target}.md"
    return vault / "10_daily" / f"{target}.md"


def _read_daily_identities(vault: Path) -> set[str]:
    daily = _daily_path(vault)
    if not daily.exists():
        return set()
    pattern = re.compile(r"^- \[(.)\]\s+.+\[(tsks:[^\]]+)\]\s*$")
    identities = set()
    for line in daily.read_text(encoding="utf-8").splitlines():
        match = pattern.match(line)
        if match:
            identities.add(match.group(2))
    return identities


def parse_task_identity(line: str) -> str | None:
    match = re.match(r"^- \[(.)\]\s+(.+?)\s+\[(tsks:[^\]]+)\]$", line)
    if not match:
        return None
    return match.group(3)


def insert_backlog_items(
    text: str,
    items: list[dict],
) -> str:
    lines = text.splitlines()
    # queue.md has no section header; use full body after front matter.
    start_idx = 0
    if lines and lines[0].strip() == "---":
        for i in range(1, len(lines)):
            if lines[i].strip() == "---":
                start_idx = i + 1
                break
    prefix = lines[:start_idx]
    suffix = []

    new_lines = []
    seen = set()
    for item in items:
        system = item.get("system")
        org = item.get("organization")
        proj = item.get("project")
        key = item.get("key")
        title = item.get("title") or ""
        if not (system and org and proj and key):
            continue
        ident = f"tsks:{system}:{org}/{proj}:{key}"
        if ident in seen:
            continue
        seen.add(ident)
        if title.startswith("[PR] "):
            title = title[len("[PR] ") :]
        project_tag = _project_tag_for_item(system, proj)
        new_lines.append(format_task_line(" ", system, org, proj, key, title, project_tag))

    insert_block = []
    if new_lines:
        insert_block.extend(new_lines)
        insert_block.append("")

    updated_section = insert_block
    updated = prefix + updated_section + suffix

    output = "\n".join(updated)
    if output and not output.endswith("\n"):
        output += "\n"
    return output


def main() -> int:
    home = Path.home()
    vault = Path(os.environ.get("OBS_VAULT", home / "src/github/k4h4shi/k4h4shi.com/vault"))
    backlog = Path(os.environ.get("TSKS_BACKLOG", vault / "15_tasks/queue.md"))
    if not backlog.exists():
        raise SystemExit(f"backlog not found: {backlog}")

    config_path = Path(
        os.environ.get("TSKS_CONFIG", home / ".config/local-env/tsks/config.yaml")
    )
    config = load_config(config_path)
    github_cfg = config.get("github", {})
    jira_cfg = config.get("jira", {})
    include_repos = github_cfg.get("include_repos") or []
    jira_projects = jira_cfg.get("projects") or []

    items = []
    if have("gh"):
        items.extend(collect_github_items(include_repos))
    if have("jira"):
        items.extend(collect_jira_items(jira_projects))
    items.extend(collect_obsidian_items(vault))

    if not items:
        return 0

    daily_identities = _read_daily_identities(vault)
    text = load_backlog(backlog)
    text = update_front_matter(text)
    if daily_identities:
        filtered = []
        for item in items:
            system = item.get("system")
            org = item.get("organization")
            proj = item.get("project")
            key = item.get("key")
            if not (system and org and proj and key):
                continue
            ident = f"tsks:{system}:{org}/{proj}:{key}"
            if ident in daily_identities:
                continue
            filtered.append(item)
        items = filtered
    text = insert_backlog_items(text, items)
    backlog.write_text(text, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
