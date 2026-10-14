import gleam/list
import gleam/string
import gleeunit
import lustre/element
import nashkell_site/drawings
import nashkell_site/page

pub fn main() -> Nil {
  gleeunit.main()
}

fn html() -> String {
  element.to_document_string(page.document())
}

pub fn every_section_is_on_the_page_and_in_the_jump_list_test() {
  let h = html()
  assert list.all(page.sections, fn(s) {
    string.contains(h, "id=\"" <> s.0 <> "\"")
    && string.contains(h, "href=\"#" <> s.0 <> "\"")
  })
}

// The page says what it could not check, and what the repository lacks.
pub fn the_page_says_what_is_not_verified_and_what_is_missing_test() {
  let h = html()
  assert string.contains(h, "not verified at the source")
  assert string.contains(h, "there is no licence file")
  assert string.contains(h, "it is not a result")
}

// No link of the page goes out over plain HTTP, and the page loads no script.
pub fn links_are_secure_and_there_is_no_script_test() {
  let h = html()
  assert !string.contains(h, "href=\"http://")
  assert !string.contains(h, "<script")
}

pub fn the_page_names_the_commit_it_describes_test() {
  assert string.contains(html(), page.read_at)
}

// Each drawing has its equations on the page, and each curve becomes a path of 241 points.
pub fn every_drawing_shows_its_equations_test() {
  let h = html()
  assert list.length(drawings.all()) == 4
  assert list.all(drawings.all(), fn(d) {
    d.curves != []
    && list.all(d.curves, fn(c) {
      list.length(drawings.points(c)) == 241
      && string.contains(h, string.replace(drawings.equation(c), "<", "&lt;"))
    })
  })
}

// The picture does not move between two builds.
pub fn a_drawing_is_the_same_each_time_test() {
  let assert [first, ..] = drawings.all()
  let assert [curve, ..] = first.curves
  assert drawings.path(curve) == drawings.path(curve)
  assert string.starts_with(drawings.path(curve), "M")
}
