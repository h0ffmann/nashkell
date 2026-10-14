//// Drawings made of equations, in the manner of the graphing calculator Desmos: each drawing is
//// a few curves, and each curve is one equation that the page prints under the drawing. The
//// page samples every curve at build time and draws it as an SVG path, so the picture and the
//// equations cannot disagree: they are the same data.
////
//// The four drawings are things of the author's profile, h0ffmann/h0ffmann: the sea, the flame
//// that Prometheus carried, the orange boat of its icon, and Ouroboros, the snake that eats its
//// own tail.

import gleam/float
import gleam/int
import gleam/list
import gleam/string

@external(javascript, "../nashkell_site_ffi.mjs", "sin")
fn sin(x: Float) -> Float

@external(javascript, "../nashkell_site_ffi.mjs", "cos")
fn cos(x: Float) -> Float

@external(javascript, "../nashkell_site_ffi.mjs", "pi")
fn pi() -> Float

/// One curve: how to compute its points, and the equation as it is printed.
pub type Curve {
  /// y = f(x), for x from the first bound to the second.
  Explicit(equation: String, f: fn(Float) -> Float, from: Float, to: Float)
  /// (x(t), y(t)), for t from the first bound to the second.
  Parametric(
    equation: String,
    x: fn(Float) -> Float,
    y: fn(Float) -> Float,
    from: Float,
    to: Float,
  )
  /// r = f(θ), for θ from the first bound to the second.
  Polar(equation: String, r: fn(Float) -> Float, from: Float, to: Float)
}

pub type Drawing {
  Drawing(name: String, title: String, said: String, curves: List(Curve))
}

pub fn equation(curve: Curve) -> String {
  curve.equation
}

pub fn all() -> List(Drawing) {
  let tau = 2.0 *. pi()
  [
    Drawing(
      name: "sea",
      title: "the sea",
      said: "three waves, each the sum of two sines: a long swell and a short chop on top of it.",
      curves: [
        Explicit(
          "y = 0.35 sin(2x) + 0.12 sin(5x + 1) + 1    {-6 ≤ x ≤ 6}",
          fn(x) { 0.35 *. sin(2.0 *. x) +. 0.12 *. sin(5.0 *. x +. 1.0) +. 1.0 },
          -6.0,
          6.0,
        ),
        Explicit(
          "y = 0.3 sin(2x + 1.2) + 0.1 sin(6x)    {-6 ≤ x ≤ 6}",
          fn(x) { 0.3 *. sin(2.0 *. x +. 1.2) +. 0.1 *. sin(6.0 *. x) },
          -6.0,
          6.0,
        ),
        Explicit(
          "y = 0.25 sin(2x + 2.5) + 0.08 sin(7x + 2) - 1    {-6 ≤ x ≤ 6}",
          fn(x) {
            0.25 *. sin(2.0 *. x +. 2.5) +. 0.08 *. sin(7.0 *. x +. 2.0) -. 1.0
          },
          -6.0,
          6.0,
        ),
      ],
    ),
    Drawing(
      name: "flame",
      title: "the flame",
      said: "a teardrop curve stood on its round end, twice, the small one inside the large one: the fire that Prometheus carried.",
      curves: [
        Parametric(
          "(1.1 sin(t) sin(t/2)^1.5, 2 cos(t))    {0 ≤ t ≤ 2π}",
          fn(t) { 1.1 *. sin(t) *. pow(sin(t /. 2.0), 1.5) },
          fn(t) { 2.0 *. cos(t) },
          0.0,
          tau,
        ),
        Parametric(
          "(0.55 sin(t) sin(t/2)^1.5, cos(t) - 0.85)    {0 ≤ t ≤ 2π}",
          fn(t) { 0.55 *. sin(t) *. pow(sin(t /. 2.0), 1.5) },
          fn(t) { cos(t) -. 0.85 },
          0.0,
          tau,
        ),
      ],
    ),
    Drawing(
      name: "boat",
      title: "the boat",
      said: "a parabola for the hull, a line for the deck, a line for the mast and one for the sail: the boat of the profile's icon.",
      curves: [
        Explicit(
          "y = 0.35x² - 1    {-1.6 ≤ x ≤ 1.6}",
          fn(x) { 0.35 *. x *. x -. 1.0 },
          -1.6,
          1.6,
        ),
        Explicit("y = -0.1    {-1.6 ≤ x ≤ 1.6}", fn(_) { -0.1 }, -1.6, 1.6),
        Parametric(
          "(0, t)    {-0.1 ≤ t ≤ 1.9}",
          fn(_) { 0.0 },
          fn(t) { t },
          -0.1,
          1.9,
        ),
        Explicit(
          "y = 1.9 - 1.4x    {0 ≤ x ≤ 1.3}",
          fn(x) { 1.9 -. 1.4 *. x },
          0.0,
          1.3,
        ),
      ],
    ),
    Drawing(
      name: "ouroboros",
      title: "ouroboros",
      said: "a circle with a ripple for its scales, open where the head is, and a small circle for the head that bites the tail.",
      curves: [
        Polar(
          "r = 1.5 + 0.07 sin(16θ)    {0.45 ≤ θ ≤ 2π}",
          fn(a) { 1.5 +. 0.07 *. sin(16.0 *. a) },
          0.45,
          tau,
        ),
        Parametric(
          "(1.45 cos(0.3) + 0.22 cos(t), 1.45 sin(0.3) + 0.22 sin(t))    {0 ≤ t ≤ 2π}",
          fn(t) { 1.45 *. cos(0.3) +. 0.22 *. cos(t) },
          fn(t) { 1.45 *. sin(0.3) +. 0.22 *. sin(t) },
          0.0,
          tau,
        ),
      ],
    ),
  ]
}

fn pow(x: Float, e: Float) -> Float {
  case float.power(float.absolute_value(x), e) {
    Ok(v) ->
      case x <. 0.0 {
        True -> 0.0 -. v
        False -> v
      }
    Error(_) -> 0.0
  }
}

/// The points of a curve: 240 steps from its first bound to its second.
pub fn points(curve: Curve) -> List(#(Float, Float)) {
  let steps = 240
  let at = fn(from: Float, to: Float, i: Int) {
    from +. { to -. from } *. int.to_float(i) /. int.to_float(steps)
  }
  upto(steps, [])
  |> list.map(fn(i) {
    case curve {
      Explicit(_, f, from, to) -> {
        let x = at(from, to, i)
        #(x, f(x))
      }
      Parametric(_, x, y, from, to) -> {
        let t = at(from, to, i)
        #(x(t), y(t))
      }
      Polar(_, r, from, to) -> {
        let a = at(from, to, i)
        #(r(a) *. cos(a), r(a) *. sin(a))
      }
    }
  })
}

/// The integers from 0 to n, in order.
fn upto(n: Int, acc: List(Int)) -> List(Int) {
  case n < 0 {
    True -> acc
    False -> upto(n - 1, [n, ..acc])
  }
}

fn fixed(x: Float) -> String {
  // One place after the point is enough for a picture 300 units wide.
  let tenths = float.round(x *. 10.0)
  let sign = case tenths < 0 {
    True -> "-"
    False -> ""
  }
  let a = int.absolute_value(tenths)
  sign <> int.to_string(a / 10) <> "." <> int.to_string(a % 10)
}

/// The SVG path of a curve, in a box from -3 to 3 on both axes, drawn 50 units to 1.
pub fn path(curve: Curve) -> String {
  points(curve)
  |> list.index_map(fn(p, i) {
    let x = 150.0 +. 50.0 *. p.0
    let y = 150.0 -. 50.0 *. p.1
    case i {
      0 -> "M" <> fixed(x) <> " " <> fixed(y)
      _ -> "L" <> fixed(x) <> " " <> fixed(y)
    }
  })
  |> string.join(" ")
}
