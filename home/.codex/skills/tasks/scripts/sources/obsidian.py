import re
from pathlib import Path


TASK_ID_RE = re.compile(r"^task_id:\\s*([a-z0-9]{6})\\s*$")
TASK_STATUS_RE = re.compile(r"^task_status:\\s*([a-zA-Z0-9_-]+)\\s*$")


def _read_task_meta(path: Path) -> tuple[str | None, str | None]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        return None, None
    task_id = None
    task_status = None
    for line in lines[1:]:
        if line.strip() == "---":
            break
        stripped = line.strip()
        match = TASK_ID_RE.match(stripped)
        if match:
            task_id = match.group(1)
            continue
        status_match = TASK_STATUS_RE.match(stripped)
        if status_match:
            task_status = status_match.group(1).lower()
    return task_id, task_status


def _link_title(title: str, rel_path: str, needs_path: bool) -> str:
    if needs_path:
        target = rel_path[:-3] if rel_path.endswith(".md") else rel_path
        return f"[[{target}|{title}]]"
    return f"[[{title}]]"


def collect_obsidian_items(vault: Path) -> list[dict]:
    tasks_dir = vault / "15_tasks"
    if not tasks_dir.exists():
        return []

    files = sorted(tasks_dir.rglob("*.md"))
    if not files:
        return []

    stems = {}
    for path in files:
        stems[path.stem] = stems.get(path.stem, 0) + 1

    items = []
    vault_name = vault.name
    for path in files:
        task_id, task_status = _read_task_meta(path)
        if not task_id:
            continue
        if task_status in {"done", "canceled"}:
            continue
        title = path.stem
        rel_path = path.relative_to(vault).as_posix()
        needs_path = stems.get(title, 0) > 1
        link = _link_title(title, rel_path, needs_path)
        items.append(
            {
                "title": link,
                "system": "obsidian",
                "organization": vault_name,
                "project": "tasks",
                "key": task_id,
            }
        )
    return items
