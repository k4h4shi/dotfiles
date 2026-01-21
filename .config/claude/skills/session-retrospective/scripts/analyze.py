#!/usr/bin/env python3
"""
Session Retrospective Analyzer

セッションログを分析し、Claude Code の設定改善を提案する。
"""

import argparse
import json
import os
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


def get_claude_projects_dir() -> Path:
    """Get the Claude projects directory."""
    return Path.home() / ".claude" / "projects"


def get_debug_dir() -> Path:
    """Get the Claude debug directory."""
    return Path.home() / ".claude" / "debug"


def project_path_to_dir_name(project_path: str) -> str:
    """Convert a project path to the Claude projects directory name format."""
    # Claude uses a specific format: -Users-name-path-to-project
    return project_path.replace("/", "-")


def find_session_files(project_path: str, recent: int = 5) -> list[Path]:
    """Find session JSONL files for a project."""
    projects_dir = get_claude_projects_dir()
    dir_name = project_path_to_dir_name(project_path)

    # Find matching directories (including worktrees)
    matching_dirs = []
    if projects_dir.exists():
        for d in projects_dir.iterdir():
            if d.is_dir() and d.name.startswith(dir_name):
                matching_dirs.append(d)

    # Collect all JSONL files from matching directories
    jsonl_files = []
    for d in matching_dirs:
        jsonl_files.extend(d.glob("*.jsonl"))

    # Sort by modification time (newest first) and return recent N
    jsonl_files.sort(key=lambda f: f.stat().st_mtime, reverse=True)
    return jsonl_files[:recent]


def find_debug_log(session_id: str) -> Path | None:
    """Find the debug log file for a session."""
    debug_dir = get_debug_dir()
    debug_file = debug_dir / f"{session_id}.txt"
    if debug_file.exists():
        return debug_file
    return None


def extract_session_id(jsonl_path: Path) -> str:
    """Extract session ID from JSONL file path."""
    return jsonl_path.stem


def parse_jsonl(file_path: Path) -> list[dict[str, Any]]:
    """Parse a JSONL file and return records."""
    records = []
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line:
                    try:
                        records.append(json.loads(line))
                    except json.JSONDecodeError:
                        continue
    except Exception as e:
        print(f"Warning: Could not parse {file_path}: {e}", file=sys.stderr)
    return records


def extract_user_messages(records: list[dict[str, Any]]) -> list[str]:
    """Extract user message content from session records."""
    messages = []
    for record in records:
        if record.get("type") == "user":
            message = record.get("message", {})
            content = message.get("content", "")
            if isinstance(content, str):
                messages.append(content)
            elif isinstance(content, list):
                # Extract text from content array
                for item in content:
                    if isinstance(item, dict) and item.get("type") == "text":
                        messages.append(item.get("text", ""))
    return messages


def extract_tool_calls(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Extract tool calls from session records."""
    tool_calls = []
    for record in records:
        if record.get("type") == "assistant":
            message = record.get("message", {})
            content = message.get("content", [])
            if isinstance(content, list):
                for item in content:
                    if isinstance(item, dict) and item.get("type") == "tool_use":
                        tool_calls.append({
                            "name": item.get("name", ""),
                            "input": item.get("input", {})
                        })
    return tool_calls


def extract_ask_user_questions(tool_calls: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Extract AskUserQuestion calls."""
    questions = []
    for call in tool_calls:
        if call.get("name") == "AskUserQuestion":
            input_data = call.get("input", {})
            question_list = input_data.get("questions", [])
            for q in question_list:
                if isinstance(q, dict):
                    questions.append({
                        "question": q.get("question", ""),
                        "header": q.get("header", ""),
                        "options": q.get("options", [])
                    })
    return questions


def extract_task_delegations(tool_calls: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Extract Task tool delegations."""
    delegations = []
    for call in tool_calls:
        if call.get("name") == "Task":
            input_data = call.get("input", {})
            delegations.append({
                "description": input_data.get("description", ""),
                "prompt": input_data.get("prompt", "")[:200],  # Truncate long prompts
                "subagent_type": input_data.get("subagent_type", "")
            })
    return delegations


def analyze_debug_log(debug_path: Path) -> dict[str, Any]:
    """Analyze debug log for permission suggestions."""
    result = {
        "suggestions": [],
        "applied": []
    }

    if not debug_path:
        return result

    try:
        with open(debug_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Find permission suggestions
        suggestion_pattern = r"Permission suggestions for (\w+):\s*\[(.*?)\]"
        for match in re.finditer(suggestion_pattern, content, re.DOTALL):
            tool_name = match.group(1)
            suggestions_str = match.group(2)
            result["suggestions"].append({
                "tool": tool_name,
                "raw": suggestions_str.strip()
            })

        # Find applied permissions
        applied_pattern = r'Applying permission update:.*?"([^"]+)"'
        for match in re.finditer(applied_pattern, content):
            result["applied"].append(match.group(1))

    except Exception as e:
        print(f"Warning: Could not analyze debug log {debug_path}: {e}", file=sys.stderr)

    return result


def find_repeated_patterns(all_messages: list[str], min_occurrences: int = 2) -> list[dict[str, Any]]:
    """Find repeated patterns in user messages across sessions."""
    # Simple approach: find repeated command sequences
    patterns = []

    # Look for command patterns (lines starting with common patterns)
    command_patterns = Counter()
    for msg in all_messages:
        # Skip very long messages (likely workflow docs)
        if len(msg) > 500:
            continue
        # Look for command-like patterns
        if msg.startswith("/") or msg.startswith("gh ") or msg.startswith("git "):
            command_patterns[msg[:100]] += 1

    for pattern, count in command_patterns.most_common(10):
        if count >= min_occurrences:
            patterns.append({
                "type": "command",
                "pattern": pattern,
                "occurrences": count,
                "suggestion": "Consider creating a skill or alias"
            })

    # Look for workflow document patterns
    workflow_markers = ["## 1.", "## Step 1", "# Implement", "# ワークフロー"]
    workflow_count = 0
    for msg in all_messages:
        if any(marker in msg for marker in workflow_markers):
            workflow_count += 1

    if workflow_count >= min_occurrences:
        patterns.append({
            "type": "workflow",
            "pattern": "Workflow documentation injected at session start",
            "occurrences": workflow_count,
            "suggestion": "Consider converting workflow to a skill"
        })

    return patterns


def find_repeated_questions(all_questions: list[dict[str, Any]], min_occurrences: int = 2) -> list[dict[str, Any]]:
    """Find questions that were asked multiple times."""
    question_counter = Counter()
    question_details = {}

    for q in all_questions:
        question_text = q.get("question", "")
        header = q.get("header", "")
        key = f"{header}:{question_text[:50]}"
        question_counter[key] += 1
        question_details[key] = q

    repeated = []
    for key, count in question_counter.most_common(10):
        if count >= min_occurrences:
            details = question_details[key]
            repeated.append({
                "question": details.get("question", ""),
                "header": details.get("header", ""),
                "occurrences": count,
                "suggestion": "Document as a rule in .mdc file"
            })

    return repeated


def find_delegation_patterns(all_delegations: list[dict[str, Any]], min_occurrences: int = 2) -> list[dict[str, Any]]:
    """Find repeated Task delegation patterns."""
    delegation_counter = Counter()
    delegation_details = {}

    for d in all_delegations:
        subagent = d.get("subagent_type", "")
        desc = d.get("description", "")
        key = f"{subagent}:{desc}"
        delegation_counter[key] += 1
        delegation_details[key] = d

    repeated = []
    for key, count in delegation_counter.most_common(10):
        if count >= min_occurrences:
            details = delegation_details[key]
            repeated.append({
                "subagent_type": details.get("subagent_type", ""),
                "description": details.get("description", ""),
                "occurrences": count,
                "suggestion": "Consider defining as a custom agent"
            })

    return repeated


def analyze_sessions(project_path: str, recent: int = 5, session_id: str | None = None) -> dict[str, Any]:
    """Main analysis function."""
    result = {
        "project": project_path,
        "analyzed_sessions": 0,
        "session_ids": [],
        "permissions": {
            "suggested": [],
            "applied": [],
            "reason": ""
        },
        "repeated_patterns": [],
        "ask_user_questions": [],
        "task_delegations": [],
        "rules": []
    }

    # Find session files
    if session_id:
        # Find specific session
        projects_dir = get_claude_projects_dir()
        dir_name = project_path_to_dir_name(project_path)
        matching_dirs = [d for d in projects_dir.iterdir() if d.is_dir() and d.name.startswith(dir_name)]
        session_files = []
        for d in matching_dirs:
            f = d / f"{session_id}.jsonl"
            if f.exists():
                session_files.append(f)
    else:
        session_files = find_session_files(project_path, recent)

    if not session_files:
        result["error"] = f"No session files found for project: {project_path}"
        return result

    # Collect data from all sessions
    all_messages = []
    all_tool_calls = []
    all_questions = []
    all_delegations = []
    all_permission_suggestions = []
    all_permission_applied = []

    for session_file in session_files:
        session_id = extract_session_id(session_file)
        result["session_ids"].append(session_id)

        # Parse session JSONL
        records = parse_jsonl(session_file)

        # Extract user messages
        messages = extract_user_messages(records)
        all_messages.extend(messages)

        # Extract tool calls
        tool_calls = extract_tool_calls(records)
        all_tool_calls.extend(tool_calls)

        # Extract AskUserQuestion calls
        questions = extract_ask_user_questions(tool_calls)
        all_questions.extend(questions)

        # Extract Task delegations
        delegations = extract_task_delegations(tool_calls)
        all_delegations.extend(delegations)

        # Analyze debug log
        debug_path = find_debug_log(session_id)
        if debug_path:
            debug_analysis = analyze_debug_log(debug_path)
            all_permission_suggestions.extend(debug_analysis["suggestions"])
            all_permission_applied.extend(debug_analysis["applied"])

    result["analyzed_sessions"] = len(session_files)

    # Process permissions
    if all_permission_suggestions:
        suggestion_counter = Counter()
        for s in all_permission_suggestions:
            suggestion_counter[s.get("tool", "")] += 1

        for tool, count in suggestion_counter.most_common(5):
            if tool:
                result["permissions"]["suggested"].append({
                    "tool": tool,
                    "occurrences": count
                })

        result["permissions"]["reason"] = f"{len(all_permission_suggestions)}回の許可待ちが発生"

    result["permissions"]["applied"] = list(set(all_permission_applied))

    # Find repeated patterns
    result["repeated_patterns"] = find_repeated_patterns(all_messages)

    # Find repeated questions
    result["ask_user_questions"] = find_repeated_questions(all_questions)

    # Find delegation patterns
    result["task_delegations"] = find_delegation_patterns(all_delegations)

    # Generate rule suggestions from repeated questions
    for q in result["ask_user_questions"]:
        if q["occurrences"] >= 2:
            result["rules"].append({
                "name": q.get("header", "unknown").lower().replace(" ", "-"),
                "reason": f"同じ質問が{q['occurrences']}回繰り返された",
                "keywords": [q.get("header", "")]
            })

    return result


def main():
    parser = argparse.ArgumentParser(description="Analyze Claude Code session logs")
    parser.add_argument("--project", "-p", default=os.getcwd(),
                        help="Project path to analyze (default: current directory)")
    parser.add_argument("--recent", "-r", type=int, default=5,
                        help="Number of recent sessions to analyze (default: 5)")
    parser.add_argument("--session-id", "-s",
                        help="Analyze a specific session ID")
    parser.add_argument("--format", "-f", choices=["json", "markdown"], default="json",
                        help="Output format (default: json)")

    args = parser.parse_args()

    # Normalize project path
    project_path = os.path.abspath(args.project)

    # Run analysis
    result = analyze_sessions(project_path, args.recent, args.session_id)

    if args.format == "json":
        print(json.dumps(result, indent=2, ensure_ascii=False))
    else:
        # Markdown output
        print(f"# Session Retrospective Report\n")
        print(f"**Project**: `{result['project']}`")
        print(f"**Analyzed Sessions**: {result['analyzed_sessions']}\n")

        if result.get("error"):
            print(f"**Error**: {result['error']}\n")
            return

        print("## Session IDs\n")
        for sid in result["session_ids"]:
            print(f"- `{sid}`")
        print()

        if result["permissions"]["suggested"]:
            print("## Permission Suggestions\n")
            print(f"*{result['permissions']['reason']}*\n")
            for p in result["permissions"]["suggested"]:
                print(f"- `{p['tool']}` ({p['occurrences']} occurrences)")
            print()

        if result["permissions"]["applied"]:
            print("## Applied Permissions\n")
            for p in result["permissions"]["applied"]:
                print(f"- `{p}`")
            print()

        if result["repeated_patterns"]:
            print("## Repeated Patterns\n")
            for p in result["repeated_patterns"]:
                print(f"### {p['type'].title()}")
                print(f"- **Pattern**: {p['pattern']}")
                print(f"- **Occurrences**: {p['occurrences']}")
                print(f"- **Suggestion**: {p['suggestion']}")
                print()

        if result["ask_user_questions"]:
            print("## Repeated Questions\n")
            for q in result["ask_user_questions"]:
                print(f"- **{q['header']}**: {q['question'][:50]}...")
                print(f"  - Occurrences: {q['occurrences']}")
                print(f"  - Suggestion: {q['suggestion']}")
            print()

        if result["task_delegations"]:
            print("## Task Delegation Patterns\n")
            for d in result["task_delegations"]:
                print(f"- **{d['subagent_type']}**: {d['description']}")
                print(f"  - Occurrences: {d['occurrences']}")
                print(f"  - Suggestion: {d['suggestion']}")
            print()

        if result["rules"]:
            print("## Suggested Rules\n")
            for r in result["rules"]:
                print(f"- **{r['name']}**: {r['reason']}")
            print()


if __name__ == "__main__":
    main()
