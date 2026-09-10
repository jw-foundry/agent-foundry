#!/usr/bin/env bash
# Stop hook — the turn cannot end until the work is published.
set -uo pipefail
cat >/dev/null

[ -n "${FOUNDRY_ISSUE:-}" ] || exit 0
command -v gh >/dev/null 2>&1 || exit 0

now=$(gh issue view "$FOUNDRY_ISSUE" --json comments -q '.comments | length' 2>/dev/null) || exit 0
min=${FOUNDRY_MIN_COMMENTS:-1}
[ "${now:-0}" -ge "$min" ] && exit 0

{
  echo "STOP BLOCKED: issue #$FOUNDRY_ISSUE has $now comments; this run must add one (needs $min)."
  echo
  echo "You have not published anything, so this run has produced nothing."
  echo "Do these in order, and do not end your turn until the last succeeds:"
  echo "  1. If any subagent is still running, WAIT and read what it returned."
  echo "     Do not summarize what you expect it to say."
  echo "  2. Write the full comment to /tmp/foundry-comment.md"
  echo "  3. gh issue comment $FOUNDRY_ISSUE --body-file /tmp/foundry-comment.md"
  echo "  4. Confirm: gh issue view $FOUNDRY_ISSUE --json comments -q '.comments|length'"
} >&2
exit 2
