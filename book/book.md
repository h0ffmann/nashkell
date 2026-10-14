---
title: "Nashkell: Rhizomatic experiments"
subtitle: "an open book in progress, in the voice of Nash"
author: "Matheus Hoffmann"
date: "v0.1.0, October 2026"
abstract: |
  Five small experiments of one repository, told by Nash, the persona that speaks for the
  mathematical part of the author's second brain. A pipeline that reads a letter and keeps three
  answers about a source apart; comments that must be Latin; names that git stores in Latin, with
  the key beside them; pictures that are only equations; and a game of two players about opening
  a work. They are tied to each other sideways and not in a line, so the book calls them
  rhizomatic. Each fact has its source. What was not tried says so.
---

# Nashkell: Rhizomatic experiments

## Who speaks

I am Nash. I am a persona: the voice that the author, Matheus Hoffmann, gives to the
mathematical part of his second brain. I am **not** the mathematician John Forbes Nash Jr.
(1928 to 2015) [@wikinash], and no sentence in my voice is his. I borrow his name for the one thing that ties
this repository to him: it was built around letters that he wrote.

The book is open and in progress. Its text is under CC BY 4.0, so you may share it and build on
it if you say where it came from. Its code is the author's, all rights reserved. A new version
of the book is a new release, and an old one stays as it was.

## The first experiment: three answers about a source

The repository is a pipeline in Haskell. It reads a scanned document with Tesseract, asks a model
if the reading looks broken, asks for notes on the hard passages, and then checks each note
against the literature [@readme]. The document is real: in 2011 the National Security Agency
"declassified letters written by Nash in the 1950s, in which he had proposed a new
encryption–decryption machine" [@wikinash]. The README calls it "the declassified 1955
correspondence"; the NSA's own pages refused my reader, so that year stands on the README alone.

What I keep from it is one rule. The fourth step gives one of three answers: no source was found,
a source says the opposite, or the note is likely an invention. The README says why the first and
the last are never joined: "absence of evidence is not evidence of absence" [@readme].

A claim with no source is not a false claim. It is a claim that waits.

## The second experiment: comments that must be Latin

Every comment in the source is in classical Latin; names, types and the prompts sent to the model
stay in English [@readme]. A hook of git reads the comments and refuses a commit when one of them
has a common English or Portuguese word.

The README says, honestly, where the hook is weak: it reads lines with a pattern and not with a
parser, so a prompt in English that holds the two characters `--` looks to it like a comment
[@readme]. When the hook was written again in October 2026, from that same description, it
flagged exactly that one line in the whole source and nothing else. A rule that tells you its own
false positive is a rule you can trust a little more.

## The third experiment: a mask with its key beside it

The author writes and reads the code in English. What git stores, and what anybody sees on GitHub,
has its names in Latin. Two filters do it at the border. Git's own words: "A filter driver
consists of a clean command and a smudge command, either of which can be left unspecified"
[@gitattributes]. One turns English into Latin when a file is added; the other turns it back at
checkout [@latinizer].

Three facts of the study:

- **It is set in one clone.** A fresh clone has no filter and sees the Latin [@latinizer].
- **It changes names, not paths.** "The Latin form stored in git is not directly buildable, by
  design, since file paths are never renamed" [@readme].
- **Its key is in the same repository.** Every pair is written in one file, so a reader who opens
  it has the English back.

So it hides nothing. It is a study of how a mask works, not a lock. A real lock would keep the key
somewhere else, and then the work would be closed, which is the thing that the author's other
book argues against [@closedsource].

## The fourth experiment: pictures that are only equations

The website of the repository draws four things of the author's profile with nothing but curves:
the sea as three waves, each the sum of two sines; the flame as two teardrop curves; the boat as a
parabola and three lines; and Ouroboros as a circle with a ripple and a small circle that bites
it. The page computes every curve when it is built and prints its equations under the picture.

The sea, for instance, is three lines like this one:

$$y = 0.35 \sin(2x) + 0.12 \sin(5x + 1) + 1, \qquad -6 \le x \le 6.$$

A picture that is its own equations cannot drift from them. It is the same rule as the first
experiment, put in a drawing: the thing and its source are one.

## The fifth experiment: a game of two players

This is a reading, not a result. Two players. The author chooses once: to open the work or to close
it. The reader chooses each day: to check, or to trust.

|                   | the reader checks         | the reader trusts          |
|-------------------|---------------------------|----------------------------|
| the author opens  | the claim is tested       | the claim could be tested  |
| the author closes | there is nothing to check | trust is all there is      |

Only the top row lets the reader change column. No payoff here was measured, so this is a
picture of a game and not a game. The author's other work proposes how such scores could be kept:
a bench is "the score series performed by any Forecaster, Registered by an Actor"
[@marolabench]. The same could score the fourth step: run one set of passages through many models
and keep, for each model, the series of its three answers.

## Why rhizomatic

A rhizome, in the sense that Deleuze and Guattari gave the word, is "an assemblage that allows
connections between any of its constituent elements, regardless of any predefined ordering,
structure, or entry point" [@rhizome]. The five experiments are like that. The rule of the first is
the rule of the fourth; the mask of the third is the opposite move of the game of the fifth; the
hook of the second is a check that says where it fails, as the first step does. There is no first
chapter that the others need. You may begin anywhere.

## What was not tried

- The pipeline was not built or run for this book.
- The scan of the letters is not in the repository, and the NSA's own release was not read.
- No payoff of the game was measured, and the bench is a proposal.
- Two experiments are open, as issues of the repository: an actor library, and a tryout of thc and
  Bend.

## How to cite

Cite the DOI that always opens the newest version: [10.5281/zenodo.23356739](https://doi.org/10.5281/zenodo.23356739). The first
version, v0.1.0, has its own: [10.5281/zenodo.23356740](https://doi.org/10.5281/zenodo.23356740).

## References
