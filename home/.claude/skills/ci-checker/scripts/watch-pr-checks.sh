#!/usr/bin/env bash
set -euo pipefail

pr=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pr)
      pr="${2:-}"; shift 2 ;;
    -*)
      echo "unknown flag: $1" >&2; exit 2 ;;
    *)
      break ;;
  esac
done

if [[ -z "${pr}" ]]; then
  pr="$(gh pr view --json number -q .number 2>/dev/null || true)"
fi

if [[ -z "${pr}" ]]; then
  echo "PR number is required. Use: --pr <number>" >&2
  exit 2
fi

repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"

echo "## CI Check Result"
echo
echo "- repo: ${repo}"
echo "- pr: #${pr}"
echo
echo "### Status"
echo "watching (gh pr checks --watch)"
echo

# NOTE: --watch は内部的にポーリングだが、利用者側で sleep ポーリングをしないための標準手段。
if ! gh pr checks "${pr}" --watch; then
  echo
  echo "### Result"
  echo "**fail**"
  echo
  echo "### Failed logs (excerpt)"

  # 直近の run を拾って failed log を抜粋して返す（原因特定はしない）
  run_id="$(gh run list --limit 1 --json databaseId -q '.[0].databaseId' 2>/dev/null || true)"
  if [[ -n "${run_id}" ]]; then
    gh run view "${run_id}" --log-failed || true
    echo
    echo "### Next steps"
    echo "- gh run view ${run_id} --log-failed"
    echo "- ローカルで該当の lint/test/build/e2e を再現"
  else
    echo "(could not resolve latest run id)"
    echo
    echo "### Next steps"
    echo "- gh run list --limit 5"
    echo "- gh pr checks ${pr}"
  fi

  exit 1
fi

echo
echo "### Result"
echo "**pass**"
echo
echo "### Next steps"
echo "- 追加対応がなければ review-checker へ"

