import os

from .utils import run_json, run_text


def gh_owner() -> str:
    owner = os.environ.get("GITHUB_OWNER", "").strip()
    if owner:
        return owner
    return run_text(["gh", "api", "user", "-q", ".login"])


def _split_repo(repo_name: str) -> tuple[str | None, str | None]:
    if "/" not in repo_name:
        return None, None
    org, proj = repo_name.split("/", 1)
    return org or None, proj or None


def _normalize_items(items: list[dict]) -> list[dict]:
    normalized = []
    for item in items:
        repo = item.get("repository", {})
        repo_name = repo.get("nameWithOwner") or repo.get("name") or ""
        org, proj = _split_repo(repo_name)
        number = item.get("number")
        normalized.append(
            {
                "title": item.get("title") or "",
                "system": "github",
                "organization": org,
                "project": proj,
                "key": str(number) if number is not None else None,
            }
        )
    return normalized


def _search_issues(args: list[str]) -> list[dict]:
    cmd = [
        "gh",
        "search",
        "issues",
        "--state",
        "open",
        "--json",
        "title,number,repository",
    ] + args
    return _normalize_items(run_json(cmd))


def _search_prs(args: list[str]) -> list[dict]:
    cmd = [
        "gh",
        "search",
        "prs",
        "--state",
        "open",
        "--json",
        "title,number,repository",
    ] + args
    return _normalize_items(run_json(cmd))


def collect_github_items(include_repos: list[str] | None = None) -> list[dict]:
    owner = gh_owner()
    items = []
    if include_repos:
        for repo in include_repos:
            items.extend(_search_issues(["--assignee", "@me", "--repo", repo]))
            items.extend(_search_issues(["--repo", repo]))
            items.extend(_search_prs(["--review-requested", "@me", "--repo", repo]))
            items.extend(_search_prs(["--author", "@me", "--repo", repo]))
            items.extend(_search_prs(["--assignee", "@me", "--repo", repo]))
    else:
        items.extend(_search_issues(["--assignee", "@me"]))
        items.extend(_search_issues(["--owner", owner, "--limit", "200"]))
        items.extend(_search_prs(["--review-requested", "@me"]))
        items.extend(_search_prs(["--owner", owner, "--limit", "200"]))

    deduped = []
    seen = set()
    for item in items:
        system = item.get("system")
        org = item.get("organization")
        proj = item.get("project")
        key = item.get("key")
        if not (system and org and proj and key):
            continue
        ident = f"{system}:{org}/{proj}:{key}"
        if ident in seen:
            continue
        seen.add(ident)
        deduped.append(item)
    return deduped
