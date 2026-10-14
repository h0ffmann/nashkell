# References

Where each fact of the website (`site/`) and of the notes (`notes/`) was read. A fact that was
not checked at its source says so. Written on 14 October 2026, with the repository at commit
`5a2d3cc`.

| What the page says | Where it was read | The passage | Status |
|---|---|---|---|
| the four steps of the pipeline; Tesseract is called as a program; three kinds of answer | [`README.md`](README.md), first section and "Design notes" | "Runs OCR on a scanned document via Tesseract (invoked as an external process, not FFI)"; "distinguishing \"no source found\" from \"contradicted\" from \"likely fabricated.\"" | verified, in this repository |
| "absence of evidence is not evidence of absence" | [`README.md`](README.md), "Design notes" | "absence of evidence is not evidence of absence. Collapsing the two into one \"unconfirmed\" bucket would silently discard that distinction." | verified, in this repository |
| the letters of John Nash to the NSA | Wikipedia, "John Forbes Nash Jr.", revision [1379797696](https://en.wikipedia.org/w/index.php?title=John_Forbes_Nash_Jr.&oldid=1379797696) of 12 October 2026 | "In 2011, the National Security Agency declassified letters written by Nash in the 1950s, in which he had proposed a new encryption–decryption machine." | partial: an encyclopedia, not the source |
| his doctoral thesis on non-cooperative games was 28 pages | Wikipedia, "John Forbes Nash Jr.", revision [1379797696](https://en.wikipedia.org/w/index.php?title=John_Forbes_Nash_Jr.&oldid=1379797696) | "Nash earned a PhD in 1950 with a 28-page dissertation on noncooperative games." | partial: an encyclopedia. "in his manner of publishing as I read it" is the persona's reading, not a fact |
| the headline "GAME THEORY: The best game ever by Nash" | the owner, 14 October 2026 | — | the owner's words, kept as he wrote them; "Nash" is the persona of `PERSONAS.md` |
| the year 1955 of those letters | [`README.md`](README.md) | "the declassified 1955 correspondence between John Nash and the NSA" | **not verified**: nsa.gov answered 403 ("Access Denied") to two requests on 14 October 2026. The scan is not in this repository |
| a filter of git has a clean and a smudge command | git, [gitattributes](https://git-scm.com/docs/gitattributes), "filter" | "A filter driver consists of a clean command and a smudge command, either of which can be left unspecified." | verified |
| the pairs Nashkell and Nashcellum, Pipeline and Series, Retry and Conatus, Effect and Effectus | [`tools/dictionary.json`](tools/dictionary.json), `_modules` | the four pairs, as written there | verified, in this repository |
| what is translated and what is not; the filter is set in one clone | [`README-latinizer.md`](README-latinizer.md) | "Only **top-level** definitions, via a fixed bijective dictionary"; "it is **not** something GitHub or a fresh clone gets automatically" | verified, in this repository |
| the Latin form does not build | [`README.md`](README.md), "Identifier obfuscation" | "the Latin form stored in git is not directly buildable, by design, since file paths are never renamed" | verified, in this repository; the build was not tried |
| the file is `Pipeline.hs` and its module is `Nashcellum.Series` | [`src/Nashkell/Pipeline.hs`](src/Nashkell/Pipeline.hs), line 1 | `module Nashcellum.Series` | verified, in this repository |
| the dictionary is in the repository, so the mask hides nothing from who opens it | `git ls-files` at `5a2d3cc` lists `tools/dictionary.json` | — | verified; "a study and not a lock" is a reading |
| the comment in Latin that the page shows | [`src/Nashkell/Pipeline.hs`](src/Nashkell/Pipeline.hs), lines 19 and 20 | "Summa totius operis: textus originarius, iudicium de qualitate, commentarii, et comprobationes fontium -- omnia in una structura." | verified, in this repository |
| the first commit is "Sic Mundus Creatus Est" | `git log` | commit `38a92af`, 24 August 2026 | verified |
| `.githooks/` was named and missing; two recipes called `tools/biblical-commit.sh`, which never existed | `git ls-files` at `5a2d3cc`; [`README.md`](README.md); [`justfile`](justfile) | — | verified. On 14 October 2026 the hook was written again from the README's description, and the two recipes and the default image were taken out |
| the justfile says it was not run | [`justfile`](justfile), its first comment | "hoc iustfile non fuit contra verum ligamentum \"just\" probatum in ambitu quo scriptum est" | verified, in this repository |
| all rights reserved; the Haskell has no tests | [`LICENSE`](LICENSE), [`REUSE.toml`](REUSE.toml); `git ls-files` | — | verified. The licence was added on 14 October 2026, by the owner's request to fix what the page listed |
| the four drawings and their equations | [`site/src/nashkell_site/drawings.gleam`](site/src/nashkell_site/drawings.gleam) | each curve is computed from the equation that the page prints | verified by the tests of `site/` |
| the idea of a bench | marola-bench, doi [10.5281/zenodo.23352633](https://doi.org/10.5281/zenodo.23352633) | — | the reading of the note "a bench for the fourth step"; marola-bench's paper was not quoted |
| the game of two players | none | — | a reading by the agent that drafted the page (Claude), for the owner to keep or change. No payoff was measured |
| a TV audience is a competition; the owner estimated one as a contractor; the game theory came later | the owner, 14 October 2026 (the same note in h0ffmann/closed-source, `notes/202610141830-tv-audience-is-competition.md`) | — | the owner's account of his own work, not checked further; the game's players, strategies and payoffs are the note's reading. The broadcaster is not named |
| the six DOIs of the author's other works | the profile, [h0ffmann/h0ffmann](https://github.com/h0ffmann/h0ffmann), `REUSE.md` | — | verified there, not here |

## Not read

- The scan of the letters, and the NSA's own release.
- The Haskell beyond `Pipeline.hs`: the page describes the other modules by what the README says.
- Nothing was built or run: not the pipeline, not the filter, not the hook.
