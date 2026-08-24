{
  description = "Nashkell -- an algebraic-effects OCR + LLM verification pipeline";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        hsPkgs = pkgs.haskell.packages.ghc98;
        nashkell = hsPkgs.callCabal2nix "nashkell" ./. { };
      in
      {
        packages.default = nashkell;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ nashkell.env ];
          buildInputs = with pkgs; [
            hsPkgs.cabal-install
            hsPkgs.haskell-language-server
            hsPkgs.ormolu
            hsPkgs.hlint

            # Dependentia nativa externa: hic fixatur ne versio
            # Tesseract inter machinas variet. Notandum: nomen exacti
            # attributi pro linguae anglicae datis (tessdata) variare
            # potest inter versiones nixpkgs -- verifica localiter
            # cum "nix search nixpkgs tesseract" si haec linea deficit.
            tesseract
            leptonica
          ];

          shellHook = ''
            echo "Nashkell dev shell -- GHC $(ghc --numeric-version 2>/dev/null || echo '?'), $(tesseract --version 2>/dev/null | head -1)"
          '';
        };
      });
}
