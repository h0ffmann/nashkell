# The first record

## Challenge

The owner asked for the first Zenodo record of nashkell: "Nashkell: Rizomatic experiments", an
open book in progress, in the voice of John Nash, the mathematical part of his second brain.

## Context

- nashkell was all rights reserved since #5.
- Zenodo's GitHub webhook made two of the owner's records wrong before: it ignored
  `"access_right": "closed"` in `.zenodo.json`, and with no `license` it took the licence that
  GitHub showed for the default branch (h0ffmann/h0ffmann, `journal/`, "the record came out open").
- John Nash was a real person (1928 to 2015). A book in his voice could put invented words in his
  mouth.

## Options

1. Keep everything all rights reserved and mark the record closed: Zenodo may ignore it again.
2. Open the book's text, keep the code closed, and say so in `.zenodo.json` with a `license`.
3. Name the narrator "John Nash" with a notice, or name a persona "Nash".

## Decision

The owner chose, on 14 October 2026: the book's text CC BY 4.0, the code all rights reserved;
and the narrator a persona named "Nash", which says on the title page and in `PERSONAS.md` that
it is not John Nash and that no sentence in its voice is his.

## Result

`book/book.md` renders to four pages (`just book`). `.zenodo.json` names the type (book), the
licence (CC BY 4.0) and open access. No release was cut: that is the owner's act (`RELEASES.md`).

## Lessons

- Write the licence into `.zenodo.json`. Do not rely on access settings that the webhook may
  ignore.
- A persona of a real person needs its notice where the reader meets it first: the title page.
