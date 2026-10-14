//// The one page of nashkell's site. Every fact on it is in REFERENCES.md at the root of the
//// repository, with where it was read; a sentence that is a reading and not a fact says so on
//// the page. Lower case, after picasso's README; an acronym and a name keep their capitals.

import gleam/list
import lustre/attribute.{attribute as a}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import nashkell_site/drawings

pub const repo = "https://github.com/h0ffmann/nashkell"

/// The commit of the repository that the page describes.
pub const read_at = "5a2d3cc"

/// The sections, in order: an id and the words of its heading.
pub const sections = [
  #("pipeline", "the pipeline"),
  #("letters", "the letters"),
  #("game", "why open source, as a game"),
  #("obfuscation", "a study of obfuscation, with Git and Latin"),
  #("latin", "comments in Latin"),
  #("faults", "what is not right in it"),
  #("equations", "drawn with equations"),
  #("record", "the record"),
]

fn link(href: String, label: String) -> Element(msg) {
  html.a([attribute.href(href), attribute.rel("noopener")], [html.text(label)])
}

fn p(text: String) -> Element(msg) {
  html.p([], [html.text(text)])
}

fn quote(words: String, from: Element(msg)) -> Element(msg) {
  html.figure([attribute.class("quote")], [
    html.blockquote([], [html.text("“" <> words <> "”")]),
    html.figcaption([], [from]),
  ])
}

fn section(
  id: String,
  light: String,
  body: List(Element(msg)),
) -> Element(msg) {
  let title = case list.key_find(sections, id) {
    Ok(t) -> t
    Error(_) -> id
  }
  html.section([attribute.id(id), attribute.class("part " <> light)], [
    html.h2([], [html.text(title)]),
    ..body
  ])
}

fn drawing(name: String, alt: String) -> Element(msg) {
  html.span(
    [
      attribute.class("drawing"),
      attribute.role("img"),
      a("aria-label", alt),
      attribute.style("mask-image", "url(drawings/" <> name <> ".svg)"),
      attribute.style("-webkit-mask-image", "url(drawings/" <> name <> ".svg)"),
    ],
    [],
  )
}

/// One cell of the game: what the author does, what the reader does, and what follows.
fn cell(
  kind: String,
  author: String,
  reader: String,
  result: String,
) -> Element(msg) {
  html.div([attribute.class("cell " <> kind)], [
    html.span([attribute.class("moves")], [
      html.text(author <> " / " <> reader),
    ]),
    html.strong([], [html.text(result)]),
  ])
}

fn cover() -> Element(msg) {
  html.header([attribute.class("cover")], [
    html.div([], [
      html.p([attribute.class("where")], [
        link("https://h0ffmann.github.io/h0ffmann/", "matheus hoffmann"),
        html.text(" / game theory"),
      ]),
      html.h1([], [html.text("nashkell")]),
      html.p([attribute.class("epithet")], [
        html.text("game theory, in Haskell, with Latin on top"),
      ]),
      html.p([attribute.class("lede")], [
        html.text(
          "a small pipeline that reads a scanned letter, asks a model what it says, and then asks where that is written. it was built around the letters that John Nash sent to the NSA in the 1950s. its comments are in Latin, and git stores its names in Latin too.",
        ),
      ]),
      html.nav(
        [attribute.class("jump"), a("aria-label", "sections")],
        list.map(sections, fn(s) { link("#" <> s.0, s.1) }),
      ),
    ]),
    drawing("matrix", "two players and a table of four cells, one line each"),
  ])
}

fn pipeline() -> Element(msg) {
  section("pipeline", "chalk", [
    p(
      "four steps, each one an effect in Polysemy, so that each can be swapped or tested alone.",
    ),
    html.ol([attribute.class("steps")], [
      html.li([], [
        html.text(
          "read the scan with Tesseract, called as a program and not through bindings.",
        ),
      ]),
      html.li([], [
        html.text(
          "ask a model if the text that came out looks broken by the reading.",
        ),
      ]),
      html.li([], [
        html.text(
          "ask a model for notes on the hard passages, each one marked as a guess.",
        ),
      ]),
      html.li([], [
        html.text(
          "check each note against the literature, and say which of three things it found: no source, a source that says the opposite, or a likely invention.",
        ),
      ]),
    ]),
    quote(
      "absence of evidence is not evidence of absence. Collapsing the two into one \"unconfirmed\" bucket would silently discard that distinction.",
      link(
        repo <> "/blob/" <> read_at <> "/README.md",
        "README.md, design notes",
      ),
    ),
    p(
      "that one rule is the part of this repository that the later work kept: a claim with no source is not a false claim, and neither is a true one.",
    ),
  ])
}

fn letters() -> Element(msg) {
  section("letters", "yellow", [
    drawing("letter", "a letter and its envelope, one line"),
    p(
      "the test case is one real document. the README calls it “the declassified 1955 correspondence between John Nash and the NSA”.",
    ),
    quote(
      "In 2011, the National Security Agency declassified letters written by Nash in the 1950s, in which he had proposed a new encryption–decryption machine.",
      link(
        "https://en.wikipedia.org/w/index.php?title=John_Forbes_Nash_Jr.&oldid=1379797696",
        "Wikipedia, “John Forbes Nash Jr.”, revision 1379797696",
      ),
    ),
    html.p([attribute.class("warn")], [
      html.text(
        "not verified at the source: the NSA's own pages answered “access denied” when this page was written, so the year 1955 stands on the README alone. the scan is not in this repository.",
      ),
    ]),
  ])
}

fn game() -> Element(msg) {
  section("game", "red", [
    p(
      "a reading, drawn as a game of two players. it is not a result: no payoff here was measured.",
    ),
    html.div([attribute.class("matrix"), a("aria-label", "the game")], [
      cell(
        "good",
        "the author opens",
        "the reader checks",
        "the claim is tested",
      ),
      cell(
        "fair",
        "the author opens",
        "the reader trusts",
        "the claim could be tested",
      ),
      cell(
        "bad",
        "the author closes",
        "the reader checks",
        "there is nothing to check",
      ),
      cell(
        "worst",
        "the author closes",
        "the reader trusts",
        "trust is all there is",
      ),
    ]),
    p(
      "an author chooses a row once. a reader chooses a column every day. only the top row lets the reader change column, and that is the whole case for it. the pipeline above is the same game at a small size: a model writes a note, and the fourth step is a reader who checks.",
    ),
    html.p([], [
      html.text("the long form of this argument is a book, "),
      link(
        "https://doi.org/10.5281/zenodo.23333656",
        "closed source: the god that failed",
      ),
      html.text(", by the same author."),
    ]),
  ])
}

fn obfuscation() -> Element(msg) {
  section("obfuscation", "blue", [
    drawing("mask", "a face and the mask it wears, one line"),
    p(
      "the code is written and read in English on the author's disk. what git stores, and what GitHub shows, has its names in Latin. two filters do it at the border.",
    ),
    quote(
      "A filter driver consists of a clean command and a smudge command, either of which can be left unspecified.",
      link("https://git-scm.com/docs/gitattributes", "git, gitattributes"),
    ),
    html.dl([attribute.class("pairs")], [
      html.dt([], [html.text("Nashkell")]),
      html.dd([], [html.text("Nashcellum")]),
      html.dt([], [html.text("Pipeline")]),
      html.dd([], [html.text("Series")]),
      html.dt([], [html.text("Retry")]),
      html.dd([], [html.text("Conatus")]),
      html.dt([], [html.text("Effect")]),
      html.dd([], [html.text("Effectus")]),
    ]),
    p("what the study found, in the repository's own words and files:"),
    html.ul([], [
      html.li([], [
        html.text(
          "only names that the project defines are translated, from a fixed list of pairs. local names, library names, strings and comments stay.",
        ),
      ]),
      html.li([], [
        html.text(
          "“the Latin form stored in git is not directly buildable, by design, since file paths are never renamed”: the file is still Pipeline.hs, and inside it the module is Nashcellum.Series.",
        ),
      ]),
      html.li([], [
        html.text(
          "the filter is set in one clone's own config. a fresh clone does not get it, and sees the Latin.",
        ),
      ]),
      html.li([], [
        html.text(
          "the list of pairs is a file of this repository, tools/dictionary.json. so nothing is hidden from a reader who opens it: this is a study of how such a mask works, and not a lock.",
        ),
      ]),
    ]),
  ])
}

fn latin() -> Element(msg) {
  section("latin", "chalk", [
    p(
      "every comment in the source is in classical Latin; names, types and the prompts sent to the model stay in English. the README says a hook of git refuses a commit with a comment in another language, and says where the hook is weak: it reads lines with a pattern and not with a parser, so it takes one English prompt for a comment.",
    ),
    html.pre([], [
      html.code([], [
        html.text(
          "-- Summa totius operis: textus originarius, iudicium de qualitate,\n-- commentarii, et comprobationes fontium -- omnia in una structura.",
        ),
      ]),
    ]),
    html.p([], [
      html.text("the first commit is named "),
      html.em([], [html.text("sic mundus creatus est")]),
      html.text(": so the world was made."),
    ]),
  ])
}

fn faults() -> Element(msg) {
  section("faults", "red", [
    p("read at commit " <> read_at <> ". a reader should know:"),
    html.ul([], [
      html.li([], [
        html.text(
          "the README and the justfile name files that are not in the repository: the folder .githooks/, tools/biblical-commit.sh and golden/sample.png.",
        ),
      ]),
      html.li([], [
        html.text(
          "the justfile says of itself, in Latin, that it was not run where it was written.",
        ),
      ]),
      html.li([], [html.text("there are no tests, and two commits.")]),
      html.li([], [
        html.text(
          "there is no licence file, so no licence is given. the code can be read; it cannot be reused.",
        ),
      ]),
      html.li([], [
        html.text("the pipeline was not built or run for this page."),
      ]),
    ]),
  ])
}

fn equations() -> Element(msg) {
  section("equations", "yellow", [
    p(
      "four things of the author's profile, each drawn only with equations, the way people draw with the graphing calculator Desmos. the page computes every curve when it is built, so each picture is exactly its equations. type the lines into a graphing calculator to draw them again.",
    ),
    html.div(
      [attribute.class("plots")],
      list.map(drawings.all(), fn(d) {
        html.figure([attribute.class("plot"), attribute.id("draw-" <> d.name)], [
          svg.svg(
            [
              a("viewBox", "0 0 300 300"),
              a("role", "img"),
              a("aria-label", d.title <> ": " <> d.said),
            ],
            list.map(d.curves, fn(c) { svg.path([a("d", drawings.path(c))]) }),
          ),
          html.figcaption([], [
            html.strong([], [html.text(d.title)]),
            html.span([], [html.text(d.said)]),
          ]),
          html.pre([], [
            html.code([], [
              html.text(
                d.curves |> list.map(drawings.equation) |> string_join("\n"),
              ),
            ]),
          ]),
        ])
      }),
    ),
    html.p([], [
      html.text("the four are from "),
      link("https://h0ffmann.github.io/h0ffmann/", "the author's profile"),
      html.text(
        ": the sea of his work, the flame of \"the aquatic prometheus\", the orange boat of its icon, and Ouroboros, the name of the friends' research.",
      ),
    ]),
  ])
}

fn string_join(items: List(String), sep: String) -> String {
  case items {
    [] -> ""
    [first, ..rest] -> list.fold(rest, first, fn(acc, s) { acc <> sep <> s })
  }
}

fn record() -> Element(msg) {
  section("record", "yellow", [
    html.p([], [
      html.text("each fact of this page, with where it was read, is in "),
      link(repo <> "/blob/main/REFERENCES.md", "REFERENCES.md"),
      html.text(". the ideas behind it are in "),
      link(repo <> "/blob/main/notes/index.md", "three notes"),
      html.text(", one idea each."),
    ]),
    html.p([], [
      html.text(
        "nashkell has no DOI yet. the author's other works have one each: ",
      ),
      link("https://doi.org/10.5281/zenodo.23224155", "marola"),
      html.text(", "),
      link("https://doi.org/10.5281/zenodo.23221351", "ww3-gpu"),
      html.text(", "),
      link("https://doi.org/10.5281/zenodo.23352633", "marola-bench"),
      html.text(", "),
      link("https://doi.org/10.5281/zenodo.23311208", "picasso"),
      html.text(", "),
      link("https://doi.org/10.5281/zenodo.23333656", "closed source"),
      html.text(", and "),
      link("https://doi.org/10.5281/zenodo.23352630", "his profile"),
      html.text("."),
    ]),
  ])
}

fn foot() -> Element(msg) {
  html.footer([], [
    html.p([], [
      html.text("made with "),
      link("https://gleam.run", "Gleam"),
      html.text(" and "),
      link("https://claude.com/claude-code", "Claude Code"),
      html.text(
        ". the one-line drawings were drawn for this page, after the manner of ",
      ),
      link("https://github.com/h0ffmann/picasso", "picasso"),
      html.text("'s. "),
      link(repo, "the source"),
      html.text("."),
    ]),
  ])
}

pub fn view() -> Element(msg) {
  html.main([], [
    cover(),
    pipeline(),
    letters(),
    game(),
    obfuscation(),
    latin(),
    faults(),
    equations(),
    record(),
    foot(),
  ])
}

pub fn document() -> Element(msg) {
  html.html([attribute.lang("en")], [
    html.head([], [
      html.meta([attribute.charset("utf-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.content("width=device-width, initial-scale=1"),
      ]),
      html.title([], "nashkell: game theory, in Haskell, with Latin on top"),
      html.meta([
        attribute.name("description"),
        attribute.content(
          "a pipeline around John Nash's letters to the NSA, why open source as a game of two players, and a study of obfuscation with git filters and Latin.",
        ),
      ]),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.googleapis.com"),
      ]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href(
          "https://fonts.googleapis.com/css2?family=Syne:wght@600;800&family=Literata:ital,opsz,wght@0,7..72,400;0,7..72,600;1,7..72,400&family=IBM+Plex+Mono:wght@400;500&display=swap",
        ),
      ]),
      html.link([attribute.rel("stylesheet"), attribute.href("style.css")]),
    ]),
    html.body([], [view()]),
  ])
}
