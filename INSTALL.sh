#!/usr/bin/env bash
# Push this plugin to the org and wire the org placeholder into templates.
#   cd ~/foundry/plugin && ./INSTALL.sh
set -euo pipefail
[ -f "$HOME/foundry/.env" ] && . "$HOME/foundry/.env"
: "${FOUNDRY_ORG:?set FOUNDRY_ORG in ~/foundry/.env first}"

sed -i '' "s|ORG_PLACEHOLDER|$FOUNDRY_ORG|g" templates/*.yml
echo "▸ templates point at $FOUNDRY_ORG"

if [ ! -d .git ]; then
  git init -q -b main
  git add -A
  git commit -qm "agent-foundry: initial roster, hooks and templates

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>"
  gh repo create "$FOUNDRY_ORG/agent-foundry" --private --source=. --push
else
  git add -A
  git commit -qm "Update agent roster and templates" || echo "▸ nothing to commit"
  git push -q
fi

echo "▸ pushed. Now: claude → /plugin marketplace add https://github.com/$FOUNDRY_ORG/agent-foundry.git"
