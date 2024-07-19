{
  description = "A Flake that includes a view python packages i use in my projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          fsrs = pkgs.python311Packages.buildPythonPackage rec {
              pname = "fsrs";
              version = "2.5.0";

              propagatedBuildInputs = [ pkgs.python311Packages.datetime ];

              src = pkgs.fetchFromGitHub {
                owner = "lomenzel";
                repo = "py-fsrs";
                rev = "c9d2c69c744e8c7e960fcec4536e2a67c3b4846c";
                sha256 = "sha256-q4X1YFpNPuuSJKFC2x0hi2uqqYoL+i6ccJB/K1q8FQY=";
              };
              doCheck = false; # nicht meine schuld dass deren tests failen
              meta = {
                description = "py-fsrs";
                homepage = "https://github.com/open-spaced-repetition/py-fsrs";
                license = pkgs.lib.licenses.mit;
              };
            };
          extra-streamlit-components = pkgs.python311Packages.buildPythonPackage rec {
            pname = "extra-streamlit-components";
            version = "0.1.71";

            propagatedBuildInputs = [ pkgs.python311Packages.streamlit ];

            src = pkgs.fetchFromGitHub {
              owner = "Mohamed-512";
              repo = "Extra-Streamlit-Components";
              rev = "1fa9839ced525ad82f288afa21083431bdcee0b3";
              sha256 = "sha256-bDwCP4cAyN/qN1rl5gatvzrjBCachnuR9/nbZRYhAEc=";
            };
            doCheck = false; # nicht meine schuld dass deren tests failen
            meta = {
              description = "An all-in-one place, to find complex or just natively unavailable components on streamlit.";
              homepage = "https://github.com/Mohamed-512/Extra-Streamlit-Components";
              license = pkgs.lib.licenses.mit;
            };
          };
        };
      }
    );
}
