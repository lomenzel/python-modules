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
        packages = {

          streamlit-cookies-controller-src = pkgs.fetchFromGitHub {
            owner = "NathanChen198";
            repo = "streamlit-cookies-controller";
            rev = "949d52732b95250ffbebef2181d591ea9a4fbdcc";
            sha256 = "sha256-uJk6xKDQ6ACCJ38wTlpe4HtPdECFnkIvLzRJKWnrpqo=";
          };

          streamlit-cookies-controller-without-frontend = pkgs.python311Packages.buildPythonPackage rec {
            pname = "streamlit_cookies_controller";
            version = "0.0.4";

            propagatedBuildInputs = [ pkgs.python311Packages.streamlit ];

            src = self.packages.${system}.streamlit-cookies-controller-src;

            meta = {
              description = "Control client browser cookie for the site";
              homepage = "https://github.com/NathanChen198/streamlit-cookies-controller";
              license = pkgs.lib.licenses.mit;
            };
          };

          streamlit-cookies-controller =
            let
              git_src = self.packages.${system}.streamlit-cookies-controller-src;
            in
            pkgs.stdenv.mkDerivation rec {
              name = "streamlit-cookies-controller";
              src = self.packages.${system}.streamlit-cookies-controller-without-frontend;

              buildInputs = [ pkgs.python311Packages.streamlit ]

              installPhase =
                let
                  frontend-build =

                    pkgs.buildNpmPackage rec {
                      name = "st-cookie-controller-frontend";
                      pname = "st-cookie-controller-frontend";
                      src = "${git_src}/streamlit_cookies_controller/frontend";
                      npmDepsHash = "sha256-zbWpVSYi873lU84J1SG+Zf98Z+ldpA5wAeC8utLtj6s=";
                      NODE_OPTIONS = "--openssl-legacy-provider";
                    };

                in
                ''
                  mkdir -p $out/lib/python3.11/site-packages/streamlit_cookies_controller/frontend
                  cp -r $src/lib $out
                  cp -r $src/nix-support $out
                  cp -r ${frontend-build}/lib/node_modules/cookie_controller/build $out/lib/python3.11/site-packages/streamlit_cookies_controller/frontend
                '';

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
            doCheck = false; # nicht meine schuld dass deren tests failen
            meta = {
              description = "py-fsrs";
              homepage = "https://github.com/open-spaced-repetition/py-fsrs";
              license = pkgs.lib.licenses.mit;
            };
          };

        };
      }
    );
}
