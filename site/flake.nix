{
  description = "nashkell's website and its checks: Gleam and Lustre from h0ffmann/picasso's gleam-website lab, and the Markdown analysers from the same pinned nixpkgs";

  # Its own flake and its own lock, beside the Haskell one at the root: the site and the checks
  # need no GHC, and the pipeline needs no Gleam. `nix flake update` here picks up a new lab.
  inputs.gleam-website.url = "github:h0ffmann/picasso?dir=labs/gleam-website";

  outputs = { gleam-website, ... }: {
    devShells = builtins.mapAttrs
      (system: shells:
        let pkgs = gleam-website.inputs.nixpkgs.legacyPackages.${system}; in
        shells // {
          # `just md-quality`, `just reuse`: markdownlint-cli2, Vale, lychee and reuse.
          md = pkgs.mkShell { packages = [ pkgs.markdownlint-cli2 pkgs.vale pkgs.lychee pkgs.reuse pkgs.git pkgs.python3 ]; };
        })
      gleam-website.devShells;
  };
}
