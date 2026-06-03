#!/usr/bin/env bash
#
# One-time push of the DLI Advisory site to a new GitHub repo.
# 1. Create an EMPTY repo in the DLI Team GitHub (no README/license/.gitignore).
# 2. Paste its URL into REMOTE_URL below.
# 3. Run:  bash push-to-github.sh
#
set -euo pipefail

# ---- EDIT THIS ONE LINE ----------------------------------------------------
REMOTE_URL="https://github.com/Bahlmannator/dliadvisory-website.git"
# ----------------------------------------------------------------------------

BRANCH="main"
cd "$(dirname "$0")"

if [ "$REMOTE_URL" = "https://github.com/YOUR-ORG/dliadvisory-website.git" ]; then
  echo "ERROR: set REMOTE_URL to your real repo URL first." >&2
  exit 1
fi

if [ ! -d .git ]; then
  git init
  git branch -M "$BRANCH"
fi

git add .
git commit -m "Initial commit: DLI Advisory static site" || echo "Nothing new to commit."

if git remote | grep -q '^origin$'; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin "$BRANCH"

echo ""
echo "Pushed to $REMOTE_URL"
echo "Next: in the repo on GitHub, go to Settings > Pages > Build and deployment"
echo "and set Source = 'GitHub Actions'. The included workflow does the rest."
