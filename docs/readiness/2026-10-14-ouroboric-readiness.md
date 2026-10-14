# Readiness, after Ouroboric's checklist

nashkell measured against the readiness checklist of ouroboric-dev, read at
[`asgard` `dc6bd70`](https://github.com/ouroboric-dev/asgard/blob/dc6bd704f0b6c218ecc98eeb48025aed2035d7cb/templates/readiness/checklist.md)
(AGPL-3.0; its questions are named here by their ids and in a few words, and not copied). The
checklist is written for a company that builds a product; nashkell is one person's research, so
many items do not apply, and the table says which. Assessed on 14 October 2026.

The status words are the checklist's own: `met`, `partial`, `missing`, `n/a`.

## Level 1: ready to build

| Id | In a few words | Status | In nashkell |
|---|---|---|---|
| RB-01, RB-02 | charters | n/a | no company and no product; the README says what the repository is |
| RB-03, RB-04 | design doc, roadmaps | partial | issues #2, #3 and #4 are the open work; there is no roadmap |
| RB-05 | principles as `AGENTS.md` invariants | met | `AGENTS.md`, seven hard rules |
| RB-06, RB-07 | name checked, brand seed | n/a | a name of a research repository, not of a product |
| RB-08 | a licence for what is public | met | all rights reserved: `LICENSE`, `REUSE.toml`, `LICENSES/` |
| RB-09 | contribution terms | missing | no contributor agreement, code of conduct or security policy |
| RB-10 | ownership clear | met | one author; `AGENTS.md`, rule 1 |
| RB-11, RB-12 | repository shape, docs standard | partial | one repository; `AGENTS.md`, `REFERENCES.md`, `notes/`; no `docs/` tree beyond this file |
| RB-13 | budgets and caps | missing | the pipeline calls a paid API with no cap written down |
| RB-14 | revocable credentials, no secret in the repository | partial | the key is read from the environment (`AGENTS.md`, rule 5); secret scanning not checked |
| RB-15 | standards accepted | partial | the checks of `just check`; no written writing style beyond the Vale rules |
| RB-16 | research behind decisions recorded | met | `notes/` and `REFERENCES.md`; the README's design notes |
| RB-17 | journal started | missing | no journal |
| RB-18 | implementation plan | n/a | the pipeline exists; no new build is planned |
| RB-19 | open technical risks, tested first | partial | issue #4 (thc and Bend) and issue #3 (actors) are risks to try; none tried |
| RB-20 | measure of success fixed in advance | missing | the note "a bench for the fourth step" proposes one; nothing is fixed |
| RB-21 | minimal visual identity | met | the website's palette of four chalks, its three typefaces, its drawings |

## Level 2: ready to launch

Not applicable: nashkell is not deployed as a service. Its website is a static page on GitHub
Pages, published by the `site` workflow.

## Level 3: ready to promote

| Id | In a few words | Status | In nashkell |
|---|---|---|---|
| RP-01 | voice guide | partial | the site is lower case, short sentences, after picasso's README; not written as a guide |
| RP-02 | journal with measured results | missing | no journal, no measurement |
| RP-03 | launch copy, humanized | n/a | no launch |
| RP-04 | nothing secret or private published | partial | no secret found in the tracked files; not scanned by a tool |

## What to do next, in order

1. A journal (`journal/`), with the first entry: why the Latin mask is a study and not a lock.
2. A cap on the paid API, written down (RB-13).
3. A security policy and a short contribution note (RB-09).
4. A measure fixed in advance, if the owner wants the bench (RB-20).
