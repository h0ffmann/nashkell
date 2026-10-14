//// The one page of nashkell's site, in the look of h0ffmann/closed-source (a black field, yellow
//// letters, a red band, black on paper) and in the manner of a short mathematical paper: each
//// part is a numbered section of definitions, propositions and remarks, told by Nash, the persona
//// of the author (PERSONAS.md). Every fact is in REFERENCES.md, with where it was read; a sentence
//// that is a reading says so. The headline is the owner's, 14 October 2026.

import gleam/int
import gleam/list
import gleam/string
import lustre/attribute.{attribute as a}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import nashkell_site/drawings

pub const repo = "https://github.com/h0ffmann/nashkell"

/// The commit of the repository that the page describes.
pub const read_at = "5a2d3cc"

/// The book's DOIs, as Zenodo minted them on 14 October 2026 (RELEASES.md): the concept DOI,
/// which always opens the newest version, and the DOI of v0.1.0 alone.
pub const doi = "10.5281/zenodo.23356739"

pub const version_doi = #("v0.1.0", "10.5281/zenodo.23356740")

/// The headline, as the owner wrote it.
pub const headline = "GAME THEORY:"

pub const headline_tail = "The best game ever by Nash"

/// The sections, in order: an id and the words of its heading.
pub const sections = [
  #("equations", "pictures that are equations"),
  #("pipeline", "three answers about a source"),
  #("letters", "the letters"),
  #("game", "a game of two players"),
  #("obfuscation", "a mask with its key beside it"),
  #("latin", "comments in Latin"),
  #("faults", "what is not right in it"),
  #("record", "the book and the record"),
  #("cite", "how to cite"),
]

fn link(href: String, label: String) -> Element(msg) {
  html.a([attribute.href(href), attribute.rel("noopener")], [html.text(label)])
}

fn p(text: String) -> Element(msg) {
  html.p([], [html.text(text)])
}

fn t(s: String) -> Element(msg) {
  html.text(s)
}

/// A numbered statement, in the manner of a short paper: its kind, its number, its words.
fn statement(
  kind: String,
  n: String,
  body: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("statement " <> string.lowercase(kind))], [
    html.p([], [
      html.span([attribute.class("label")], [html.text(kind <> " " <> n <> ".")]),
      html.text(" "),
      ..body
    ]),
  ])
}

fn quote(words: String, from: Element(msg)) -> Element(msg) {
  html.figure([attribute.class("quote")], [
    html.blockquote([], [html.text("“" <> words <> "”")]),
    html.figcaption([], [from]),
  ])
}

fn section(id: String, body: List(Element(msg))) -> Element(msg) {
  let found =
    list.index_map(sections, fn(s, i) { #(s, i) })
    |> list.find(fn(x) { x.0.0 == id })
  let #(n, title) = case found {
    Ok(#(s, i)) -> #(int.to_string(i + 1), s.1)
    Error(_) -> #("", id)
  }
  html.section([attribute.id(id), attribute.class("part")], [
    html.h2([], [
      html.span([attribute.class("num")], [html.text("§" <> n)]),
      html.text(" " <> title),
    ]),
    ..body
  ])
}

/// A drawing made of equations, with every equation of it as its caption.
fn plot(d: drawings.Drawing, class: String) -> Element(msg) {
  html.figure([attribute.class(class), attribute.id(class <> "-" <> d.name)], [
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
      html.ul(
        [attribute.class("eqs")],
        list.map(d.curves, fn(c) {
          html.li([], [html.code([], [html.text(drawings.equation(c))])])
        }),
      ),
    ]),
  ])
}

/// A DOI as a two-part badge that opens doi.org, as closed-source's site has it.
fn doi_link(label: String, d: String) -> Element(msg) {
  html.a(
    [
      attribute.class("doi"),
      attribute.href("https://doi.org/" <> d),
      attribute.rel("noopener"),
    ],
    [html.span([], [html.text(label)]), html.span([], [html.text(d)])],
  )
}

fn doi_line() -> Element(msg) {
  html.p([attribute.class("doi-line")], [
    doi_link("Latest DOI", doi),
    doi_link("Permanent DOI · " <> version_doi.0, version_doi.1),
  ])
}

fn by_name(name: String) -> List(drawings.Drawing) {
  list.filter(drawings.all(), fn(d) { d.name == name })
}

fn cover() -> Element(msg) {
  html.header([attribute.class("cover")], [
    html.div([attribute.class("field")], [
      html.p([attribute.class("where")], [
        link("https://h0ffmann.github.io/h0ffmann/", "matheus hoffmann"),
        html.text(" / nashkell"),
      ]),
      html.h1([], [
        html.span([attribute.class("head")], [html.text(headline)]),
        html.span([attribute.class("tail")], [html.text(headline_tail)]),
      ]),
      doi_line(),
    ]),
    html.div([attribute.class("band")], [
      html.text("nashkell · an open book in progress, in the voice of Nash"),
    ]),
    html.div([attribute.class("paper")], [
      html.div([attribute.class("lede")], [
        p(
          "I am Nash: the voice that the author gives to the mathematical part of his second brain. I am not the mathematician John Forbes Nash Jr., and no sentence of mine is his. I borrow his name because this repository was built around letters that he wrote.",
        ),
        p(
          "What follows is short, in his manner of publishing as I read it: a few definitions, a few propositions, and remarks on what was not proved. His own doctoral thesis on non-cooperative games was 28 pages.",
        ),
        html.nav(
          [attribute.class("jump"), a("aria-label", "sections")],
          list.index_map(sections, fn(s, i) {
            link("#" <> s.0, "§" <> int.to_string(i + 1) <> " " <> s.1)
          }),
        ),
      ]),
      html.div(
        [attribute.class("cover-plots")],
        list.flat_map(["flame", "sea"], fn(n) {
          list.map(by_name(n), plot(_, "cover-plot"))
        }),
      ),
    ]),
  ])
}

fn equations() -> Element(msg) {
  section("equations", [
    statement("Definition", "1.1", [
      t(
        "A picture is an equation drawing when every line of it is a curve with an equation, and nothing else is drawn. Each picture below carries every one of its equations as its caption.",
      ),
    ]),
    statement("Proposition", "1.2", [
      t(
        "Such a picture cannot drift from its equations: the page computes every curve from the same equation that it prints, when it is built.",
      ),
    ]),
    html.div(
      [attribute.class("plots")],
      list.map(drawings.all(), plot(_, "plot")),
    ),
    statement("Remark", "1.3", [
      t("the four are things of "),
      link("https://h0ffmann.github.io/h0ffmann/", "the author's profile"),
      t(
        ": the sea of his work, the flame of \"the aquatic prometheus\", the orange boat of its icon, and Ouroboros. they are drawn the way people draw with the graphing calculator Desmos; type the lines into one to draw them again.",
      ),
    ]),
  ])
}

fn pipeline() -> Element(msg) {
  section("pipeline", [
    statement("Definition", "2.1", [
      t(
        "The pipeline has four steps, each an effect in Polysemy: read the scan with Tesseract; ask a model if the reading looks broken; ask for notes on the hard passages, each marked as a guess; check each note against the literature.",
      ),
    ]),
    statement("Definition", "2.2", [
      t(
        "The check answers one of three things: no source was found, a source says the opposite, or the note is likely an invention.",
      ),
    ]),
    quote(
      "absence of evidence is not evidence of absence. Collapsing the two into one \"unconfirmed\" bucket would silently discard that distinction.",
      link(
        repo <> "/blob/" <> read_at <> "/README.md",
        "README.md, design notes",
      ),
    ),
    statement("Proposition", "2.3", [
      t(
        "A claim with no source is not a false claim. It is a claim that waits.",
      ),
    ]),
  ])
}

fn letters() -> Element(msg) {
  section("letters", [
    statement("Definition", "3.1", [
      t(
        "The test case is one real document. The README calls it “the declassified 1955 correspondence between John Nash and the NSA”.",
      ),
    ]),
    quote(
      "In 2011, the National Security Agency declassified letters written by Nash in the 1950s, in which he had proposed a new encryption–decryption machine.",
      link(
        "https://en.wikipedia.org/w/index.php?title=John_Forbes_Nash_Jr.&oldid=1379797696",
        "Wikipedia, “John Forbes Nash Jr.”, revision 1379797696",
      ),
    ),
    statement("Remark", "3.2", [
      html.span([attribute.class("warn")], [
        t(
          "not verified at the source: the NSA's own pages answered “access denied” when this page was written, so the year 1955 stands on the README alone. the scan is not in this repository.",
        ),
      ]),
    ]),
  ])
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

fn game() -> Element(msg) {
  section("game", [
    statement("Definition", "4.1", [
      t(
        "Two players. The author chooses once: to open the work or to close it. The reader chooses each day: to check, or to trust.",
      ),
    ]),
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
    statement("Proposition", "4.2", [
      t(
        "Only the top row lets the reader change column. That is the whole case for opening.",
      ),
    ]),
    statement("Remark", "4.3", [
      t(
        "a reading, drawn as a game. it is not a result: no payoff here was measured. the long form of the argument is a book, ",
      ),
      link(
        "https://doi.org/10.5281/zenodo.23333656",
        "closed source: the god that failed",
      ),
      t(", by the same author."),
    ]),
  ])
}

fn obfuscation() -> Element(msg) {
  section("obfuscation", [
    statement("Definition", "5.1", [
      t(
        "The code is written and read in English on the author's disk; what git stores, and what GitHub shows, has its names in Latin. Two filters of git do it at the border.",
      ),
    ]),
    quote(
      "A filter driver consists of a clean command and a smudge command, either of which can be left unspecified.",
      link("https://git-scm.com/docs/gitattributes", "git, gitattributes"),
    ),
    html.dl([attribute.class("pairs")], [
      html.dt([], [t("Nashkell")]),
      html.dd([], [t("Nashcellum")]),
      html.dt([], [t("Pipeline")]),
      html.dd([], [t("Series")]),
      html.dt([], [t("Retry")]),
      html.dd([], [t("Conatus")]),
      html.dt([], [t("Effect")]),
      html.dd([], [t("Effectus")]),
    ]),
    statement("Proposition", "5.2", [
      t(
        "The mask hides nothing. It is set in one clone, so a fresh clone sees the Latin; it changes names and not paths, so “the Latin form stored in git is not directly buildable”; and its key, the list of pairs, is a file of the same repository.",
      ),
    ]),
    statement("Remark", "5.3", [
      t("so it is a study of how such a mask works, and not a lock."),
    ]),
  ])
}

fn latin() -> Element(msg) {
  section("latin", [
    statement("Definition", "6.1", [
      t(
        "Every comment in the source is in classical Latin; names, types and the prompts sent to the model stay in English. A hook of git refuses a commit whose comments are not Latin.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        t(
          "-- Summa totius operis: textus originarius, iudicium de qualitate,\n-- commentarii, et comprobationes fontium -- omnia in una structura.",
        ),
      ]),
    ]),
    statement("Remark", "6.2", [
      t(
        "the README says where the hook is weak: it reads lines with a pattern and not with a parser. written again from that description, it flags exactly the one false positive that the README names. the first commit is called ",
      ),
      html.em([], [t("sic mundus creatus est")]),
      t(": so the world was made."),
    ]),
  ])
}

fn faults() -> Element(msg) {
  section("faults", [
    statement("Remark", "7.1", [t("the Haskell pipeline has no tests.")]),
    statement("Remark", "7.2", [
      t(
        "the justfile says of itself, in Latin, that it was not run where it was written.",
      ),
    ]),
    statement("Remark", "7.3", [
      t("the pipeline was not built or run for this page."),
    ]),
  ])
}

fn record() -> Element(msg) {
  section("record", [
    statement("Definition", "8.1", [
      html.strong([], [t("The open book: ")]),
      link("nashkell.pdf", "Nashkell: Rhizomatic experiments"),
      t(
        ", v0.1.0, in progress. Five experiments, in the voice of Nash. Its text is CC BY 4.0. Cite it as doi ",
      ),
      link("https://doi.org/10.5281/zenodo.23356739", "10.5281/zenodo.23356739"),
      t("."),
    ]),
    statement("Remark", "8.2", [
      t("each fact of this page, with where it was read, is in "),
      link(repo <> "/blob/main/REFERENCES.md", "REFERENCES.md"),
      t("; the ideas are in "),
      link(repo <> "/blob/main/notes/index.md", "the notes"),
      t(
        ". all rights reserved for the code, this page and its drawings; the book and the notes are CC BY 4.0. ",
      ),
      link(repo <> "/blob/main/LICENSE", "the licence"),
      t("."),
    ]),
    statement("Remark", "8.3", [
      t("the author's other works, each with its DOI: "),
      link("https://doi.org/10.5281/zenodo.23224155", "marola"),
      t(", "),
      link("https://doi.org/10.5281/zenodo.23221351", "ww3-gpu"),
      t(", "),
      link("https://doi.org/10.5281/zenodo.23352633", "marola-bench"),
      t(", "),
      link("https://doi.org/10.5281/zenodo.23311208", "picasso"),
      t(", "),
      link("https://doi.org/10.5281/zenodo.23333656", "closed source"),
      t(", and "),
      link("https://doi.org/10.5281/zenodo.23352630", "his profile"),
      t("."),
    ]),
  ])
}

fn cite() -> Element(msg) {
  section("cite", [
    statement("Definition", "9.1", [
      t("The two DOIs of the book, as Zenodo minted them on 14 October 2026:"),
    ]),
    html.dl([attribute.class("dois")], [
      html.dt([], [doi_link("Latest DOI", doi)]),
      html.dd([], [
        t(
          "one DOI for the whole book. It always opens the newest version. Cite this one.",
        ),
      ]),
      html.dt([], [
        doi_link("Permanent DOI · " <> version_doi.0, version_doi.1),
      ]),
      html.dd([], [
        t(
          "one DOI for "
          <> version_doi.0
          <> " alone: the same text forever. Add it when the exact wording matters.",
        ),
      ]),
    ]),
    html.pre([attribute.class("citation")], [
      html.code([], [
        t(
          "Hoffmann, M. (2026). Nashkell: Rhizomatic experiments (Version v0.1.0). Zenodo. https://doi.org/"
          <> doi
          <> "\n\n@book{hoffmann2026nashkell,\n  author    = {Hoffmann, Matheus},\n  title     = {Nashkell: Rhizomatic experiments},\n  year      = {2026},\n  version   = {v0.1.0},\n  publisher = {Zenodo},\n  doi       = {"
          <> doi
          <> "}\n}",
        ),
      ]),
    ]),
    statement("Remark", "9.2", [
      t(
        "professional citation is the argument of the author's other book. cite this one, and cite what you borrow.",
      ),
    ]),
  ])
}

fn foot() -> Element(msg) {
  html.footer([], [
    html.p([], [
      t("made with "),
      link("https://gleam.run", "Gleam"),
      t(" and "),
      link("https://claude.com/claude-code", "Claude Code"),
      t(". the look is "),
      link("https://h0ffmann.github.io/closed-source/", "closed source"),
      t("'s; the pictures are equations, after the manner of "),
      link("https://github.com/h0ffmann/picasso", "picasso"),
      t("'s one-line drawings. "),
      link(repo, "the source"),
      t("."),
    ]),
  ])
}

pub fn view() -> Element(msg) {
  html.div([], [
    cover(),
    html.main([], [
      equations(),
      pipeline(),
      letters(),
      game(),
      obfuscation(),
      latin(),
      faults(),
      record(),
      cite(),
      foot(),
    ]),
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
      html.title([], "GAME THEORY: The best game ever by Nash · nashkell"),
      html.meta([
        attribute.name("description"),
        attribute.content(
          "nashkell: an open book in progress, in the voice of Nash. a pipeline around John Nash's letters to the NSA, pictures that are equations, a game of two players, and a study of obfuscation with git filters and Latin.",
        ),
      ]),
      html.meta([
        a("property", "og:title"),
        attribute.content(headline <> " " <> headline_tail),
      ]),
      html.meta([
        a("property", "og:description"),
        attribute.content(
          "nashkell: an open book in progress, in the voice of Nash",
        ),
      ]),
      html.meta([
        a("property", "og:image"),
        attribute.content("https://h0ffmann.github.io/nashkell/og.png"),
      ]),
      html.meta([
        a("property", "og:url"),
        attribute.content("https://h0ffmann.github.io/nashkell/"),
      ]),
      html.meta([
        attribute.name("twitter:card"),
        attribute.content("summary_large_image"),
      ]),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.googleapis.com"),
      ]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href(
          "https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400;0,600;1,400&family=Playfair+Display:wght@700;900&family=Oswald:wght@500;600&family=IBM+Plex+Mono:wght@400&display=swap",
        ),
      ]),
      html.link([attribute.rel("stylesheet"), attribute.href("style.css")]),
    ]),
    html.body([], [view()]),
  ])
}
