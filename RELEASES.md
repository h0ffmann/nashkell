# Releases

Each release of the open book "Nashkell: Rizomatic experiments", with its DOI and what changed.
Only the owner cuts a release (AGENTS.md, rule 6). Zenodo's webhook archives every published
GitHub release and gives it a DOI, which is permanent.

## v0.1.0: prepared, not released

The first version of the book: five experiments in the voice of Nash, four pages.

**Before the release, the owner:**

1. turns this repository on in Zenodo's GitHub page (his account);
2. merges the pull request that brings `book/` and `.zenodo.json`;
3. cuts the release from `main`: `gh release create v0.1.0 --title "Nashkell: Rizomatic experiments, v0.1.0" --notes-file RELEASES.md`;
4. reads the record back on Zenodo at once: type "book", licence CC BY 4.0, open access, the
   title, his ORCID. Two records of his came out with the wrong terms before (journal/).

**After the release**, the DOI goes into: this file, `CITATION.cff`, the book's "How to cite",
the website's record, `REFERENCES.md`, and h0ffmann/h0ffmann and h0ffmann/closed-source (issue #2).
