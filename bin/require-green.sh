#!/usr/bin/env bash
# TaskCompleted — converts "definition of done" from a hope into a gate.
# Exit 2 prevents the task from being marked complete and tells the
# agent why, so it has to actually fix it.
set -uo pipefail

payload=$(cat)
dir=$(printf '%s' "$payload" | jq -r '.cwd // empty')
[ -n "$dir" ] && cd "$dir" 2>/dev/null || exit 0

# Nothing to verify in a repo with no test script — don't block.
[ -f package.json ] || exit 0
jq -e '.scripts.test' package.json >/dev/null 2>&1 || exit 0

if ! out=$(npm test --silent 2>&1); then
  {
    echo "Tests are failing, so this task is not complete."
    echo "Fix the failure — do not weaken or skip the test."
    echo "---"
    printf '%s\n' "$out" | tail -40
  } >&2
  exit 2
fi

exit 0
