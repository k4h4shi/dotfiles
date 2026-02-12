import os
import re
from pathlib import Path
from urllib.parse import urlparse

from .utils import run_json_optional


def _jira_org() -> str | None:
    org = os.environ.get("JIRA_ORG", "").strip()
    if org:
        return org

    server = os.environ.get("JIRA_SITE", "").strip() or os.environ.get("JIRA_SERVER", "").strip()
    if not server:
        config = Path(os.environ.get("JIRA_CONFIG_FILE", "~/.config/.jira/.config.yml")).expanduser()
        if config.exists():
            for line in config.read_text(encoding="utf-8").splitlines():
                match = re.match(r"^server:\\s*(\\S+)$", line.strip())
                if match:
                    server = match.group(1)
                    break
    if not server:
        return None

    host = urlparse(server).hostname or server
    if not host:
        return None
    return host.split(".")[0]


def _project_from_key(key: str) -> str | None:
    if "-" not in key:
        return None
    return key.split("-", 1)[0]


def collect_jira_items(projects: list[str] | None = None) -> list[dict]:
    org = _jira_org()
    if not org:
        return []

    default_jql = "assignee = currentUser() OR (issuetype in subTaskIssueTypes() AND assignee = currentUser())"
    jql = os.environ.get("JIRA_JQL", default_jql)
    if projects:
        proj_expr = ",".join(projects)
        jql = f"project in ({proj_expr}) AND ({jql})"
    items = run_json_optional(["jira", "issue", "list", "--raw", "--paginate", "0:100", "--jql", jql])

    results = []
    for item in items:
        key = item.get("key") or ""
        project = _project_from_key(key)
        if not project:
            continue
        fields = item.get("fields") or {}
        title = fields.get("summary") or ""
        results.append(
            {
                "title": title,
                "system": "jira",
                "organization": org,
                "project": project,
                "key": key,
            }
        )
    return results
