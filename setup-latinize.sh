#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
LATINIZE="$REPO_ROOT/tools/latinize.py"

chmod +x "$LATINIZE"

git config filter.latinize.clean  "python3 '$LATINIZE' clean"
git config filter.latinize.smudge "python3 '$LATINIZE' smudge"

git add --renormalize .

if git rev-parse --verify -q HEAD > /dev/null; then
  git ls-files -z -- '*.hs' | xargs -0 rm -f
  git checkout -f HEAD -- .
fi

echo "latinize filter installed. Working tree stays English;"
echo "git objects (and therefore GitHub) will store Latin identifiers."
