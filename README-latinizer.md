# nashkell-latinizer

Git `clean`/`smudge` filter pair that lets you write and read the
`nashkell` codebase in English on your own disk, while what gets
committed to git (and therefore what GitHub shows) has its identifiers
translated to Latin.

This was built and empirically validated against the real `nashkell`
source files -- not just designed on paper. See "What was actually
tested" below.

## Install (once per clone)

```bash
cd nashkell/                 # repo root, where .gitattributes lives
../nashkell-latinizer/setup-latinize.sh
```

This registers the filter in `.git/config` (local, per-clone -- like
any git filter, it is **not** something GitHub or a fresh clone gets
automatically) and forces a rewrite of already-checked-out files so
they land back in English on disk.

## How it works

Two git hooks fire at the commit/checkout boundary:

- **`clean`** (English -> Latin): runs on `git add` / `git commit`.
  Transforms your on-disk English source into what actually gets
  written to the git object database.
- **`smudge`** (Latin -> English): runs on `git checkout` / `git
  clone`. Transforms the stored Latin back into English for your
  working tree.

```
you type English on disk
        |  git add / commit
        v
   [clean filter]  ---->  Latin stored in .git objects  ---->  GitHub shows Latin
        ^
        |  git checkout / clone
   [smudge filter]
        |
you see English on disk again (only if the filter is installed)
```

Anyone who clones without running `setup-latinize.sh` sees the raw
Latin-identifier source, exactly as GitHub displays it.

## What actually gets translated

Only **top-level** definitions, via a fixed bijective dictionary in
`tools/dictionary.json`:

- module path segments (`Nashkell.Effect.Ocr` -> `Nashcellum.Effectus.Ocr`)
- type and data constructor names
- record field names
- top-level function and constant names

Deliberately **left untouched**:

- local `let`/`where`/lambda-bound variable names (e.g. `attempt`,
  `resp`, `err` inside a `do` block) -- translating these too would
  require a real Haskell parser to track scope; a flat dictionary
  substitution would risk renaming a local variable that happens to
  share a name with an unrelated top-level identifier.
- import aliases you chose (`import qualified Data.Text as T`) -- `T`
  stays `T`.
- anything from an external library (`Show`, `Eq`, `FromJSON`,
  `ExitCode`, `Nothing`, `Object`, etc.) -- the dictionary only
  contains names *we* defined, so library names never match and are
  never touched.
- `Main` / `main` -- GHC requires the entry-point module and function
  to have exactly these names; translating them would break the build
  in a way that has nothing to do with obfuscation.
- string literals and line comments -- see below.

## String- and comment-awareness (why this exists)

A naive regex substitution over raw text would happily "translate"
English words that appear inside string literals (several of our
prompt strings sent to the Anthropic API are intentionally in English)
or inside the existing Latin prose comments. `tools/latinize.py`
contains a small per-line state machine that tracks whether it is
currently inside a double-quoted string before deciding whether `--`
starts a comment -- specifically to avoid the exact false-positive
class we already hit once with `check-latin.sh` (a prompt string
containing a literal `--` as a sentence separator, not a comment
marker). Identifier substitution only ever runs on spans classified as
plain code.

## Known limitations (read before relying on this for anything real)

- **This is a line-based heuristic, not a full Haskell parser.** It
  correctly handles single-line double-quoted strings and `--` line
  comments (which is all this codebase uses), but does **not**
  understand block comments (`{- ... -}`), multi-line strings, or
  Template Haskell quasi-quotes. It would need extending before reuse
  on a codebase that uses those.
- **The Latin checkout is not directly buildable.** Because file
  *paths* are never renamed (git filters only ever touch blob
  *content*), the Latin version stored in git declares e.g. `module
  Nashcellum.Effectus.Ocr` inside a file still located at
  `src/Nashkell/Effect/Ocr.hs` -- a module-name/file-path mismatch
  that GHC will reject. This is expected, not a bug: the Latin form
  is meant to be read (or rather, not easily read) on GitHub, not
  compiled directly. Building always happens against your local
  English working tree, where names and paths are consistent by
  construction.
- **Dictionary coverage is manual, not exhaustive.** It covers every
  top-level identifier that existed in `nashkell` at the time this was
  written. Adding new top-level names to the project means adding a
  corresponding entry to `dictionary.json` -- there is no automatic
  extraction step. `git diff` after a `clean` pass is the fastest way
  to notice a name that fell through untranslated.
- **This raises, not eliminates, reading difficulty.** Renamed
  identifiers plus already-Latin comments make casual skimming (by a
  human or an LLM) meaningfully slower, but the code structure,
  control flow, and type signatures are all still fully intact and
  inferable -- this is light obfuscation for a personal/stylistic
  project, not a security boundary. Don't rely on it to protect
  anything that actually needs protecting.

## What was actually tested

All of the following was run for real against the `nashkell` source
tree in this delivery, not just asserted:

1. **Round-trip fidelity**: every `.hs` file in the project was passed
   through `clean` then `smudge` and diffed byte-for-byte against the
   original -- all seven files matched exactly, including the one file
   containing a string literal with a literal `--` inside it (the
   known false-positive shape).
2. **End-to-end git mechanics**: a scratch git repository was
   initialized, the filter installed, the project committed, and
   `git show HEAD:<path>` was inspected directly to confirm the
   *actual stored blob* (i.e. what GitHub would render) contains
   Latin identifiers while the working tree stays English.
3. **Fresh-clone behavior**: the scratch repo was cloned into a new
   directory (simulating what a stranger pulling from GitHub sees) --
   confirmed the raw clone shows Latin, and that running
   `setup-latinize.sh` there recovers a working tree byte-identical to
   the English original.
4. **A real git footgun found and fixed along the way**: `git
   checkout -f` alone was not sufficient to force the smudge filter to
   re-run on already-present files, because git compares
   `clean(working tree)` against the stored blob to decide whether a
   rewrite is needed -- and re-cleaning already-Latin text is a no-op,
   so git concluded nothing had changed and skipped calling smudge.
   `setup-latinize.sh` works around this by deleting tracked `.hs`
   files before checking them out again.
