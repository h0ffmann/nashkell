//// `just plots`: each drawing made of equations as an SVG file, and the book's title page as a
//// piece of LaTeX that sets two of them side by side, each with its equations as its caption.
//// Written into build/plots/; the book reads them from there (`just book`).

import gleam/int
import gleam/list
import gleam/string
import nashkell_site/drawings

@external(javascript, "../nashkell_site_ffi.mjs", "write_file")
fn write_file(path: String, text: String) -> Nil

/// The two plots of the title page: the flame and the sea, the fire and the water of the
/// author's epithet.
pub const cover = ["flame", "sea"]

pub fn svg(d: drawings.Drawing) -> String {
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 300 300\" fill=\"none\" stroke=\"#111111\" stroke-width=\"3\" stroke-linecap=\"round\" stroke-linejoin=\"round\">"
  <> string.concat(
    list.map(d.curves, fn(c) { "<path d=\"" <> drawings.path(c) <> "\"/>" }),
  )
  <> "</svg>\n"
}

/// LaTeX's special characters, for an equation set as plain text.
pub fn latex(s: String) -> String {
  s
  |> string.replace("\\", "\\textbackslash{}")
  |> string.replace("{", "\\{")
  |> string.replace("}", "\\}")
  |> string.replace("^", "\\^{}")
  |> string.replace("_", "\\_")
  |> string.replace("&", "\\&")
  |> string.replace("%", "\\%")
  |> string.replace("#", "\\#")
}

pub fn cover_tex() -> String {
  let parts =
    list.filter_map(cover, fn(name) {
      list.find(drawings.all(), fn(d) { d.name == name })
    })
    |> list.map(fn(d) {
      "\\begin{minipage}[t]{0.46\\textwidth}\\centering\n"
      <> "\\includegraphics[width=0.78\\textwidth]{plot-"
      <> d.name
      <> ".pdf}\\\\[2pt]\n"
      <> "{\\small\\textit{"
      <> d.title
      <> "}}\\\\[1pt]\n"
      <> "{\\scriptsize\\eqfont "
      <> string.join(list.map(d.curves, fn(c) { latex(c.equation) }), "\\\\\n")
      <> "}\n\\end{minipage}"
    })
  string.join(parts, "\\hfill\n") <> "\n"
}

/// The README's main image: the flame and the sea side by side, on paper, so that it reads on a
/// light page and on a dark one. 600 by 300, from the same curves as the site and the book.
pub fn readme_svg() -> String {
  let half = fn(name: String, dx: Int) {
    list.filter(drawings.all(), fn(d) { d.name == name })
    |> list.flat_map(fn(d) { d.curves })
    |> list.map(fn(c) {
      "<path transform=\"translate("
      <> int.to_string(dx)
      <> " 0)\" d=\""
      <> drawings.path(c)
      <> "\"/>"
    })
    |> string.concat
  }
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 600 300\" role=\"img\" aria-label=\"the flame and the sea, drawn only with equations\">"
  <> "<rect width=\"600\" height=\"300\" fill=\"#F4EFE6\"/>"
  <> "<g fill=\"none\" stroke=\"#141210\" stroke-width=\"3\" stroke-linecap=\"round\" stroke-linejoin=\"round\">"
  <> half("flame", 0)
  <> half("sea", 300)
  <> "</g><path d=\"M14 14 h34 M14 14 v34 M586 286 h-34 M586 286 v-34\" stroke=\"#A3201C\" stroke-width=\"3\" fill=\"none\"/></svg>\n"
}

pub fn main() -> Nil {
  write_file("../docs/cover.svg", readme_svg())
  list.each(drawings.all(), fn(d) {
    write_file("../build/plots/plot-" <> d.name <> ".svg", svg(d))
  })
  write_file("../build/plots/cover.tex", cover_tex())
}
