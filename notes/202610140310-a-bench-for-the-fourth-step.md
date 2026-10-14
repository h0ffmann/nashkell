---
id: "202610140310"
title: "A bench for the fourth step"
type: permanent
status: open-question
source: "a reading by Claude, 2026-10-14, after the owner asked for marola-bench's ideas in nashkell; marola-bench, doi 10.5281/zenodo.23352633"
tags: [benchmark, models, sources, marola-bench]
created: 2026-10-14
---

# A bench for the fourth step

marola-bench proposes a benchmark for forecasts of the brazilian coast: each forecaster is scored
against what the buoys measured, and the bench is the series of those scores over time
(marola-bench, doi [10.5281/zenodo.23352633](https://doi.org/10.5281/zenodo.23352633)).

The fourth step of nashkell can be scored the same way. Its truth is not a buoy but a source:
for each note that a model writes, the step answers "no source found", "contradicted" or
"likely fabricated". Run the same set of passages through several models, and each model gets
a series of answers. A model that invents sources is seen in its series, as a forecaster that
misses the waves is seen in its own.

Three things this would need, none of them here yet:

- **A fixed set** of passages, with the sources a person checked for each. It is the hidden
  test of a benchmark, and it is written before any model is scored.
- **A score** that keeps the three answers apart, as the README insists: "no source found" is
  not "likely fabricated".
- **Something that runs it** on a schedule and keeps the series. In marola-bench that is an
  actor for each forecaster; here it is the question of issue #3.

**Open question.** A reading, not a plan. The owner decides if nashkell needs a bench at all.

The rule that the score would keep: [[202610140208-a-claim-with-no-source-is-not-a-false-claim]].
