{
  description = "Flake to manage dependencies for writing LaTeX assignments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
	  (system:
	    let 
		  pkgs = nixpkgs.legacyPackages.${system};
          tex = pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-medium latexmk ifoddpage relsize mdframed zref needspace xcharter xstring xetex fontaxes amsmath lipsum enumitem glossaries listings tcolorbox environ tikzfill pdfcol sauerj;
          };
          os_font_dir = with pkgs; "${jetbrains-mono}/share/fonts/truetype:${vollkorn}/share/fonts/opentype:${fira-code}/share/fonts/truetype";
		  build_inputs = with pkgs; [
		    tex
		    rsync
		    python3
		    python3Packages.python-lsp-server
		  ];
		in
	    {
		  devShells.default = pkgs.mkShell {
		    buildInputs = build_inputs;
			shellHook = ''
			  # unset TZ # for some reason we need to do this :)
			  export TEXINPUTS="$PWD/packages//:"
			  export SOURCE_DATE_EPOCH=$(date +%s)
			  export OSFONTDIR="${os_font_dir}"
			'';
		  };
		  packages = rec {
		    documents = pkgs.stdenv.mkDerivation {
			  name = "latex-documents";
			  src = self;
			  buildInputs = build_inputs;
			  installPhase = ''
			  DIR=$(mktemp -d)
			  export TEXINPUTS="$PWD/packages//:"
			  export TEXMFHOME="$DIR/.cache"
			  export TEXMFVAR="$DIR/.texcache/texmf-var"
			  export SOURCE_DATE_EPOCH=$(date +%s)
			  export OSFONTDIR="${os_font_dir}"
			  mkdir -p $out/out
			  python3 generate_pdf
			  rsync -av --prune-empty-dirs --include='*/' --include='*.pdf' --include='CONTENTS.md' --exclude='.git' --exclude='.github' --exclude='*' ./ $out/out
			  mv $out/out/CONTENTS.md $out/out/README.md # We want to see it in GitHub
			  '';
			};
			default = documents;
		  };
		}
	  );
}
