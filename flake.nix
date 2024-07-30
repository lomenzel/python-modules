{
  description = "A Flake that includes a view python packages i use in my projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages =
          let
            streamlit-cookies-controller-src = pkgs.fetchFromGitHub {
              owner = "NathanChen198";
              repo = "streamlit-cookies-controller";
              rev = "949d52732b95250ffbebef2181d591ea9a4fbdcc";
              sha256 = "sha256-uJk6xKDQ6ACCJ38wTlpe4HtPdECFnkIvLzRJKWnrpqo=";
            };
          in

          {

            streamlit-cookies-controller = pkgs.python311Packages.buildPythonPackage rec {
              pname = "streamlit_cookies_controller";
              version = "0.0.4";

              propagatedBuildInputs = [ pkgs.python311Packages.streamlit ];

              src = streamlit-cookies-controller-src;

              postPatch =
                let
                  frontend-build = pkgs.buildNpmPackage rec {
                    name = "st-cookie-controller-frontend";
                    pname = "st-cookie-controller-frontend";
                    src = "${streamlit-cookies-controller-src}/streamlit_cookies_controller/frontend";
                    npmDepsHash = "sha256-zbWpVSYi873lU84J1SG+Zf98Z+ldpA5wAeC8utLtj6s=";
                    NODE_OPTIONS = "--openssl-legacy-provider";
                  };

                in
                ''
                  mkdir -p $out/lib/python3.11/site-packages/streamlit_cookies_controller/frontend
                  cp -r ${frontend-build}/lib/node_modules/cookie_controller/build $out/lib/python3.11/site-packages/streamlit_cookies_controller/frontend
                '';

              meta = {
                description = "Control client browser cookie for the site";
                homepage = "https://github.com/NathanChen198/streamlit-cookies-controller";
                license = pkgs.lib.licenses.mit;
              };
            };

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
              doCheck = false;
              meta = {
                description = "py-fsrs";
                homepage = "https://github.com/open-spaced-repetition/py-fsrs";
                license = pkgs.lib.licenses.mit;
              };
            };
            gooey = pkgs.python311Packages.buildPythonPackage rec {
              pname = "Gooey";
              version = "1.0.8.1";
              pyproject = true;
              propagatedBuildInputs = with pkgs.python311Packages; [
                setuptools
                pillow
                psutil
                colored
                pygtrie
                wxpython
              ];
              src = pkgs.fetchPypi {
                inherit pname version;
                hash = "sha256-CNa/U09NUNUNr7pc/Gjc8xpunu7xOpTL4+oXxORcRnE=";
              };
              meta = {
                description = "Turn (almost) any commandline program into a full GUI application with one line";
              };
            };

          };
      }
    );
}
