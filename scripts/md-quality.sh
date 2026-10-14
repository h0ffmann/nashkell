#!/usr/bin/env bash
# md-quality: three analysers over every Markdown file of nashkell.
#   - markdownlint-cli2: the structure (.markdownlint-cli2.jsonc)
#   - Vale: plain words, short sentences, numbers over adjectives (.vale.ini, .vale/styles/nashkell/)
#   - lychee: links to files and headings that do not exist; with --online, dead web links too
# The tools come from site/flake.nix's `md` shell (`just md-quality` enters it), pinned by site/flake.lock.
# Taken from marola-dev/marola-research at 51fae22 (MIT, by the same author), with its paths changed.
# The three tools and the shape (one script, a self-test, an online mode with one second try) are
# those of h0ffmann/closed-source's scripts/md-quality.sh at c52ff71; this file is written here.
#   scripts/md-quality.sh              # structure, prose, local links
#   scripts/md-quality.sh --online     # the same, and lychee fetches every web link
#   scripts/md-quality.sh --self-test  # each analyser must refuse a bad file
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

files() { git ls-files '*.md'; }
# Vale's rules are for English. An easy pt-BR version is not checked by them.
# Vale reads this repository's own English. README-latinizer.md is a design note written before the
# rules, and is left as it was.
prose() { files | grep -v 'pt-BR' | grep -v '^README-latinizer.md$' || true; }

self_test() {
  local d; d="$(mktemp -d)"; trap 'rm -rf "$d"' RETURN
  fail() { echo "md-quality: self-test: $1" >&2; exit 1; }
  printf '# A page\n## No blank line above\n\n\n\nTwo blank lines above.\n' >"$d/structure.md"
  ! markdownlint-cli2 --config .markdownlint-cli2.jsonc "$d/structure.md" >/dev/null 2>&1 \
    || fail "markdownlint passed a heading with no blank line"
  printf '# A page\n\nWe utilize a very robust tool.\n' >"$d/prose.md"
  ! vale --config .vale.ini --no-wrap "$d/prose.md" >/dev/null 2>&1 || fail "Vale passed 'utilize' and 'very'"
  printf '# A page\n\nThe source says "a highly concurrent\ntoolkit". It has 3 parts.\n' >"$d/quote.md"
  vale --config .vale.ini --no-wrap "$d/quote.md" >/dev/null 2>&1 || fail "Vale refused a word inside a quotation"
  printf '# A page\n\n[a file that is not there](not-there.md)\n' >"$d/link.md"
  ! lychee --offline --no-progress "$d/link.md" >/dev/null 2>&1 || fail "lychee passed a link to a file that does not exist"
  echo "md-quality: self-test ok: each of the three refused a bad file" >&2
}

online=0
case "${1:-}" in
  --self-test) self_test; exit 0 ;;
  --online) online=1 ;;
  "") ;;
  *) echo "md-quality: usage: scripts/md-quality.sh [--online | --self-test]" >&2; exit 1 ;;
esac

mapfile -t all < <(files)
mapfile -t english < <(prose)
bad=0

echo "md-quality: structure: markdownlint-cli2 on ${#all[@]} files" >&2
log="$(mktemp)"
markdownlint-cli2 "${all[@]}" >/dev/null 2>"$log" || { grep -E ' (error|warning) ' "$log" >&2 || cat "$log" >&2; bad=1; }
rm -f "$log"

echo "md-quality: prose: Vale on ${#english[@]} files (an error fails; a warning is advice)" >&2
vale --no-wrap --output=line "${english[@]}" >&2 || bad=1

# 403, 405 and 429 count as an answer: the site is there and refuses a robot, or asks it to slow
# down. A site that is busy for a moment must not fail a pull request, and a dead link must: each
# link is tried five times, and if one still fails lychee runs once more after a minute, which
# fetches only the links that failed (`--cache`).
# The repository's own published site is not fetched: a page that a pull request adds does not
# exist before the pull request is merged, and `site / build` is the check of what it will be.
pages='^https://h0ffmann\.github\.io/nashkell/'
if [ "$online" = 1 ]; then
  echo "md-quality: links: lychee on ${#all[@]} files, web links too" >&2
  # This repository's own workflow badges are not fetched: a badge of a workflow that a pull request
  # adds does not exist before the pull request is merged, and CI itself is the check of the workflow.
  own='^https://github\.com/h0ffmann/nashkell/actions/workflows/'
  web() {
    lychee --no-progress --include-fragments --max-concurrency 6 --max-retries 4 --retry-wait-time 5 \
      --host-concurrency 2 --host-request-interval 500ms \
      --timeout 30 --cache --max-cache-age 1h --exclude "$own" --accept 200,403,405,429 \
      --exclude "$pages" "${all[@]}" >&2
  }
  rm -f .lycheecache
  web || { echo "md-quality: links: a link did not answer; the second and last try in 60 s" >&2; sleep 60; web || bad=1; }
  rm -f .lycheecache
else
  echo "md-quality: links: lychee on ${#all[@]} files, local links (run --online for the web)" >&2
  lychee --offline --no-progress --include-fragments "${all[@]}" >&2 || bad=1
fi

[ "$bad" = 0 ] || { echo "md-quality: failed" >&2; exit 1; }
echo "md-quality: ok" >&2
