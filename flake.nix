{
  description = "Flake to manage dependencies for writing LaTeX assignments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit
            (pkgs.texlive)
            scheme-medium
            latexmk
            ifoddpage
            relsize
            zref
            needspace
            xcharter
            xstring
            xetex
            fontaxes
            amsmath
            lipsum
            enumitem
            glossaries
            listings
            listingsutf8
            tcolorbox
            environ
            tikzfill
            pdfcol
            pgfplots
            alegreya
            plex
            titlesec
            circuitikz
            multirow
            cleveref
            braket
            catppuccinpalette
            luacode
            ;
        };
        os_font_dir = with pkgs; "";
        build_inputs = with pkgs; [
          tex
          rsync
          python3
        ];
        default_tbox_theme = "LightTheme";
        build_docs = theme: ''
          echo "Building LaTeX documents using theme: ${theme}!"
          DIR=$(mktemp -d)
          export TBOX_THEME='${theme}'
          export TEXINPUTS="$PWD/packages//:"
          export TEXMFHOME="$DIR/.cache"
          export TEXMFVAR="$DIR/.texcache/texmf-var"
          export SOURCE_DATE_EPOCH=$(date +%s)
          export OSFONTDIR=${os_font_dir}
          mkdir -p $out/out
          python3 generate_pdf
          python3 generate_contents
          rsync -av --prune-empty-dirs --include='*/' --include='*.pdf' --include='CONTENTS.md' --exclude='.git' --exclude='.github' --exclude='*' ./ $out/out
          mv $out/out/CONTENTS.md $out/out/README.md
        '';
        package_derivation = theme:
          pkgs.stdenv.mkDerivation {
            name = "latex-${theme}";
            src = self;
            buildInputs = build_inputs;
            installPhase = build_docs "${theme}";
          };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = build_inputs;
          shellHook = ''
            export TBOX_THEME='${default_tbox_theme}'
            export TEXINPUTS="$PWD/packages//:"
            export SOURCE_DATE_EPOCH=$(date +%s)
            export OSFONTDIR=${os_font_dir}
          '';
        };
        packages = rec {
          default-theme-documents = package_derivation (
            # if the user is using `--impure` flag and defined the `TBOX_THEME` environment variable
            # (not recommended! unless you have so many themes or you are just testing...)
            if builtins.getEnv "TBOX_THEME" != ""
            then builtins.getEnv "TBOX_THEME"
            else default_tbox_theme
          );
          light-theme-documents = package_derivation "LightTheme";
          dark-theme-documents = package_derivation "DarkTheme";
          default = default-theme-documents;
        };
      }
    );
}
