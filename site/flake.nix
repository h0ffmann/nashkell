{
  description = "nashkell's website: Gleam and Lustre, from h0ffmann/picasso's gleam-website lab";

  # Its own flake and its own lock, beside the Haskell one at the root: the site needs no GHC, and
  # the pipeline needs no Gleam. `nix flake update` here picks up a new revision of the lab.
  inputs.gleam-website.url = "github:h0ffmann/picasso?dir=labs/gleam-website";

  outputs = { gleam-website, ... }: { devShells = gleam-website.devShells; };
}
