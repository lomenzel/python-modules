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
                rev = "7b12a9815288c8cd1b66477dc56c12fb81d535e2";
                sha256 = "sha256-3sW9hJg0QLHyFAKHrj9jyyN/tc+HKQ1m9XyTBcKVXiA=";
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
