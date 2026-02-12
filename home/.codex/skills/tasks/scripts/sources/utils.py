import json
import subprocess
import sys


def run_json(cmd: list[str]) -> list[dict]:
    proc = subprocess.run(cmd, check=True, capture_output=True, text=True)
    return json.loads(proc.stdout or "[]")


def run_json_optional(cmd: list[str]) -> list[dict]:
    try:
        return run_json(cmd)
    except subprocess.CalledProcessError as exc:
        err = (exc.stderr or "").strip()
        if err:
            print(f"warn: {err}", file=sys.stderr)
        return []


def run_text(cmd: list[str]) -> str:
    proc = subprocess.run(cmd, check=True, capture_output=True, text=True)
    return (proc.stdout or "").strip()
