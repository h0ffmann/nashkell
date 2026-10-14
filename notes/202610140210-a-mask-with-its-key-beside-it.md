---
id: "202610140210"
title: "A mask with its key beside it"
type: permanent
status: partial
source: "README-latinizer.md, tools/dictionary.json and .gitattributes of this repository at commit 5a2d3cc; git's documentation of gitattributes"
tags: [obfuscation, git, latin]
created: 2026-10-14
---

# A mask with its key beside it

The repository stores its own names in Latin. A `clean` filter of git turns the English on the
author's disk into Latin when a file is added, and a `smudge` filter turns it back at
checkout. Git's own words: "A filter driver consists of a clean command and a smudge command".

What the study shows about such a mask:

- **It is set in one clone.** A fresh clone has no filter and sees the Latin.
- **It changes names, not paths.** So the stored form does not build: the file is
  `Pipeline.hs` and its module says `Nashcellum.Series`.
- **Its key is in the same repository.** `tools/dictionary.json` holds every pair. A reader who
  opens it has the English back.

So this is a study of how a mask works at the border of git, and not a way to hide code. A
real one would keep the list of pairs out of the repository, and would then be closed source
with more steps.

**Status: partial.** The mechanism and the three points were read in the files. The filter was
not installed or run for this note. The last sentence is a reading.

The game it is a move in: [[202610140209-open-source-as-a-game-of-two]].
