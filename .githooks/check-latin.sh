#!/usr/bin/env bash
# check-latin: a comment of a Haskell file must be in Latin (README.md, "Git hooks").
# Written on 14 October 2026 from the README's own description of the hook, because the README
# named this file and the repository did not have it. The method is the README's: a line with
# `--` is taken as a comment, and fails when it has a common English or Portuguese function word.
# The README says where this is weak: a string with `--` in it is taken as a comment too.
#   .githooks/check-latin.sh <file.hs>...
set -euo pipefail
# Only words that are not also Latin: "in", "a", "de", "e", "non" and "do" are Latin words too.
words='\b(the|and|of|to|is|that|with|for|this|it|are|from|be|not|or|if|que|com|para|por|um|uma|não|está)\b'
bad=0
for f in "$@"; do
  [ -f "$f" ] || continue
  while IFS=: read -r n line; do
    comment="${line#*--}"
    if grep -qiE "$words" <<<"$comment"; then
      echo "check-latin: $f:$n: a comment that is not Latin: ${comment:0:70}" >&2
      bad=1
    fi
  done < <(grep -n -- '--' "$f" || true)
done
exit "$bad"
