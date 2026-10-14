#!/usr/bin/env bash
# release: cut a release of the open book, so that Zenodo's webhook archives it and mints its DOI.
#   just release v0.1.0
# Only the owner runs this (AGENTS.md, rule 6): a DOI is permanent. It refuses unless the tree is
# main, clean and up to date, the version is new and named in RELEASES.md, the book's references
# are whole and the committed PDF is the one its text makes. Then it creates the GitHub release.
# Zenodo must already be turned on for this repository (Zenodo's GitHub page, the owner's account).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
v="${1:?release: usage: just release vX.Y.Z}"
[[ "$v" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "release: $v is not vX.Y.Z" >&2; exit 1; }
[ "$(git branch --show-current)" = main ] || { echo "release: switch to main first" >&2; exit 1; }
git diff --quiet && git diff --cached --quiet || { echo "release: the tree has changes; commit or stash them" >&2; exit 1; }
git fetch -q origin main
[ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ] || { echo "release: main is not origin/main; pull first" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$v" >/dev/null && { echo "release: $v exists already" >&2; exit 1; }
grep -q "^## $v" RELEASES.md || { echo "release: RELEASES.md has no section '## $v'" >&2; exit 1; }
grep -q "\"version\": \"$v\"" .zenodo.json || { echo "release: .zenodo.json does not say version $v" >&2; exit 1; }
just refs
just current
notes="$(awk -v v="## $v" '$0 ~ "^"v {p=1; next} /^## / && p {exit} p' RELEASES.md)"
title="$(python3 -c 'import json; print(json.load(open(".zenodo.json"))["title"])'), $v"
echo "release: about to create $v, \"$title\". Zenodo will mint a permanent DOI for it."
read -r -p "release: type the version again to go on: " again
[ "$again" = "$v" ] || { echo "release: stopped" >&2; exit 1; }
gh release create "$v" --title "$title" --notes "$notes" --target main
echo "release: $v is out. In a few minutes, run \`just doi\`, then read the record on Zenodo:"
echo "release: type book, licence CC BY 4.0, open access, the title, the ORCID (RELEASES.md)."
