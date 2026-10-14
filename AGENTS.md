# AGENTS.md

nashkell: a pipeline in Haskell (Polysemy) around John Nash's letters to the NSA, with comments in
Latin and a git filter that stores its names in Latin, a one-page website (`site/`), notes and
references. This file is for coding agents. Read it before you change anything.

## Hard rules

1. **Authorship.** nashkell is the work of Matheus Hoffmann (`h0ffmann`, ORCID
   0009-0009-1056-7661). The open book and the notes are CC BY 4.0; the rest is all rights
   reserved (`LICENSE`, `REUSE.toml`). An agent's work is credited in the
   `Co-Authored-By` trailer of its commits, and nowhere as an author of the work.
2. **Nothing leaves.** Do not copy any part of this repository into another repository, or for
   another person, without the owner's written permission. The scripts marked MIT in
   `REUSE.toml` are the one exception, under their own licence.
3. **A fact needs a source.** A fact on the website or in a note is in `REFERENCES.md`, with
   where it was read and its status. A fact that was not checked at its source says so. Never
   invent a source, a quotation or a number.
4. **Comments are in Latin.** Names, types and the prompts sent to a model stay in English.
   `just setup-hooks` turns on the check (`.githooks/`).
5. **No secret in the repository.** The pipeline reads `ANTHROPIC_API_KEY` from the environment.
6. **Work on a branch and open a pull request.** Never merge one, never push to `main`. Only the
   owner tags or releases, and only when he asks for that release by name.
7. **Nash is a persona, not John Nash.** The open book speaks as "Nash", the author's voice for
   the mathematical part of his second brain (`PERSONAS.md`). Never write a sentence as a
   quotation of the mathematician John Forbes Nash Jr. without its source; never remove the
   notice of the title page.
8. **When you write about the author, cite his works by their DOIs**: marola
   10.5281/zenodo.23224155, ww3-gpu 10.5281/zenodo.23221351, picasso 10.5281/zenodo.23311208,
   closed source 10.5281/zenodo.23333656, marola-bench 10.5281/zenodo.23352633, and his profile
   10.5281/zenodo.23352630.

## Map

| What | Where |
|---|---|
| the pipeline | `app/`, `src/`, `nashkell.cabal`, `flake.nix` (GHC, Cabal, Tesseract) |
| the Latin of names | `tools/latinize.py`, `tools/dictionary.json`, `setup-latinize.sh`, `README-latinizer.md` |
| the website | `site/` (Gleam and Lustre); its tools in `site/flake.nix`, pinned in `site/flake.lock` |
| the drawings made of equations | `site/src/nashkell_site/drawings.gleam` |
| the open book, its sources, its look | `book/book.md`, `book/refs.bib`, `book/REFERENCES.md`, `format/`; `just book`, `just refs`, `just current` |
| releases and the Zenodo record | `RELEASES.md`, `.zenodo.json`, `CITATION.cff` |
| who speaks | `PERSONAS.md` |
| the journal | `journal/` |
| the facts and their sources | `REFERENCES.md` |
| the ideas, one in each note | `notes/`, `notes/index.md` |
| readiness, after Ouroboric's checklist | `docs/readiness/` |
| licence and copyright of every file | `REUSE.toml`, `LICENSES/` |
| citation | `.zenodo.json`, `CITATION.cff`; no DOI yet (issue #2) |

## Checks

`just check` runs what CI runs: the three Markdown analysers (`just md-quality`, with a self-test
that each must fail on a bad file), the notes (`just notes`) and the licences (`just reuse`).
`just site` builds the website and runs its tests. `just md-quality --online` fetches every web
link; the `live links` workflow runs it on each pull request.

## Sources

The rules follow h0ffmann/closed-source and marola-dev/marola-research, by the same author. The
tooling of the checks is taken from marola-dev/marola-research at `51fae22`, under MIT.
