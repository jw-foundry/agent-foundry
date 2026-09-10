#!/usr/bin/env bash
# PreToolUse:Bash — a wall, not a suggestion.
# Exit 2 blocks the call and returns stderr to the agent as the reason.
set -uo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

block() { printf 'BLOCKED: %s\nCommand: %s\n' "$1" "$cmd" >&2; exit 2; }

case "$cmd" in
  *"rm -rf /"*|*"rm -fr /"*)          block "recursive delete from root" ;;
  *"git push"*--force*|*"git push"*" -f "*) block "force-push; rewrite history is never OK here" ;;
  *"git push"*" main"*|*"git push origin main"*) block "direct push to main; open a PR" ;;
  *"git reset --hard"*origin*)        block "hard reset to remote discards work" ;;
  *"git clean -"*d*f*)                block "git clean deletes untracked work irreversibly" ;;
  *"gh pr merge"*)                    block "merging is Gate 2 and belongs to a human" ;;
  *"gh repo delete"*|*"gh api -X DELETE"*) block "destructive GitHub API call" ;;
  *sudo*)                             block "no sudo from an agent session" ;;
  *"curl"*"|"*"sh"*|*"wget"*"|"*"sh"*) block "piping a download straight into a shell" ;;
  *"chmod -R 777"*)                   block "world-writable permissions" ;;
  *".env"*">"*|*">"*".env")           block "writing to .env; secrets are managed outside the repo" ;;
esac

exit 0
