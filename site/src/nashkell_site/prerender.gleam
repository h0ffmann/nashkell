//// Writes the page as one HTML document on standard output: `just site` sends it to
//// site/dist/index.html. There is no script on the page; it is rendered once, at build.

import gleam/io
import lustre/element
import nashkell_site/page

pub fn main() -> Nil {
  io.println(element.to_document_string(page.document()))
}
