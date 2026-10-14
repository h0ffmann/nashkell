#!/usr/bin/env bash
# doi: the DOIs that Zenodo gave the open book, read from Zenodo's public API (no token).
#   just doi
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
title="$(python3 -c 'import json; print(json.load(open(".zenodo.json"))["title"])')"
curl -fsS --max-time 60 -G "https://zenodo.org/api/records" --data-urlencode "q=title:\"$title\"" \
  --data-urlencode "size=10" --data-urlencode "sort=mostrecent" | python3 -c '
import json, sys
hits = json.load(sys.stdin)["hits"]["hits"]
if not hits:
    print("doi: no record yet; Zenodo can take a few minutes after a release", file=sys.stderr); sys.exit(1)
for h in hits:
    m = h["metadata"]
    print(f"{m.get(\"version\", \"?\")}\tdoi {h[\"doi\"]}\tconcept {h.get(\"conceptdoi\", \"?\")}\t{m.get(\"license\", {}).get(\"id\", \"?\")}\t{m.get(\"resource_type\", {}).get(\"title\", \"?\")}\t{h[\"links\"][\"html\"]}")
'
