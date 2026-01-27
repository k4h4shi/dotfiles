#!/usr/bin/env bash
set -euo pipefail

pr=""
interval="30"
max="30"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pr)
      pr="${2:-}"; shift 2 ;;
    --interval)
      interval="${2:-}"; shift 2 ;;
    --max)
      max="${2:-}"; shift 2 ;;
    -*)
      echo "unknown flag: $1" >&2; exit 2 ;;
    *)
      break ;;
  esac
done

repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
owner="${repo%/*}"
name="${repo#*/}"

if [[ -z "${pr}" ]]; then
  pr="$(gh pr view --json number -q .number)"
fi

start_ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

query='
query($owner:String!,$name:String!,$pr:Int!){
  repository(owner:$owner,name:$name){
    pullRequest(number:$pr){
      reviews(last:50){
        nodes{author{login} state submittedAt body}
      }
      reviewThreads(last:100){
        nodes{
          isResolved
          comments(last:100){
            nodes{author{login} createdAt body path originalLine}
          }
        }
      }
      comments(last:100){
        nodes{author{login} createdAt body}
      }
    }
  }
}'

for _ in $(seq 1 "$max"); do
  data="$(gh api graphql -F owner="$owner" -F name="$name" -F pr="$pr" -f query="$query")"

  # jq があるなら開始時刻以降の新規だけ検知して、見つけた瞬間に終了
  if command -v jq >/dev/null 2>&1; then
    if echo "$data" | jq -e --arg ts "$start_ts" '
      [
        (.data.repository.pullRequest.reviews.nodes[]? | {t: .submittedAt, body: .body}),
        (.data.repository.pullRequest.reviewThreads.nodes[]?.comments.nodes[]? | {t: .createdAt, body: .body}),
        (.data.repository.pullRequest.comments.nodes[]? | {t: .createdAt, body: .body})
      ]
      | map(select(.t != null and .t > $ts and (.body // "" | length) > 0))
      | length > 0
    ' >/dev/null; then
      echo "$data"
      exit 0
    fi
  else
    # jq が無い場合は差分検知ができないので、取得結果をそのまま返して終了
    echo "$data"
    exit 0
  fi

  sleep "$interval"
done

echo "$data"
exit 1

