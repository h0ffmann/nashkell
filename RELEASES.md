# Releases

Each release of the open book "Nashkell: Rhizomatic experiments", with its DOI and what changed.
Only the owner cuts a release (AGENTS.md, rule 6). Zenodo's webhook archives every published
GitHub release and gives it a DOI, which is permanent.

## v0.1.0: the first version

Released on 14 October 2026. DOI [10.5281/zenodo.23356740](https://doi.org/10.5281/zenodo.23356740); the concept DOI, which always
opens the newest version, is [10.5281/zenodo.23356739](https://doi.org/10.5281/zenodo.23356739). Zenodo recorded it as a book, CC BY
4.0, open access, as `.zenodo.json` says (read back from Zenodo's API the same day).

The first version of the open book **Nashkell: Rhizomatic experiments**, in the voice of Nash,
a persona of the author (not the mathematician John Forbes Nash Jr.; no sentence in that voice is
his). Four pages, five experiments:

- three answers about a source: "no source found", "contradicted" and "likely fabricated" kept apart;
- comments that must be Latin, and a hook that says where it fails;
- a mask with its key beside it: names that git stores in Latin;
- pictures that are only equations;
- a game of two players about opening a work.

The book's text and the notes are CC BY 4.0; the code is all rights reserved. Every source is in
`book/REFERENCES.md`, with its status; what was not tried is said in the book.

## How a release is made

Only the owner releases (AGENTS.md, rule 6). Zenodo's webhook archives every published GitHub
release and gives it a DOI, which is permanent.

1. Turn this repository on in Zenodo's GitHub page (the owner's account). Without it, a release
   gets no DOI.
2. `just release vX.Y.Z` on a clean `main`: it checks the references and the PDF, asks for the
   version again, and creates the GitHub release with the notes of that version from this file.
3. `just doi` after a few minutes; then read the record on Zenodo: type book, licence CC BY 4.0,
   open access, the title, the ORCID. Two records of the owner came out with the wrong terms
   before (journal/).
4. The DOI goes into this file, `CITATION.cff`, the book's "How to cite", the website's record,
   `REFERENCES.md`, and h0ffmann/h0ffmann and h0ffmann/closed-source (issue #2).
