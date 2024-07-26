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
        streamlit-cookies-controller-npm-built = pkgs.stdenv.mkDerivation rec {
          name = "streamlit-cookies-controller-src";
          src = pkgs.fetchFromGitHub {
            owner = "NathanChen198";
            repo = "streamlit-cookies-controller";
            rev = "949d52732b95250ffbebef2181d591ea9a4fbdcc";
            sha256 = "sha256-uJk6xKDQ6ACCJ38wTlpe4HtPdECFnkIvLzRJKWnrpqo=";
          };

          installPhase =
            let
              frontend-build =
                let
                  git_src = src;
                in
                pkgs.buildNpmPackage rec {
                  name = "st-cookie-controller-frontend";
                  pname = "st-cookie-controller-frontend";
                  src = "${git_src}/streamlit_cookies_controller/frontend";
                  npmDepsHash = "sha256-zbWpVSYi873lU84J1SG+Zf98Z+ldpA5wAeC8utLtj6s=";
                  NODE_OPTIONS = "--openssl-legacy-provider";
                };
              
            in
            ''
              mkdir -p $out/streamlit_cookies_controller/frontend
              cp $src/streamlit_cookies_controller/*.py $out/streamlit_cookies_controller/
              cp $src/*.py $out/
              cp $src/README.md $out/
              cp $src/MANIFEST.in $out/
              cp -r ${frontend-build} $out/streamlit_cookies_controller/frontend
            '';

        };
      in
      {
        packages = {

  streamlit-cookies-controller-npm-built = pkgs.stdenv.mkDerivation rec {
          name = "streamlit-cookies-controller-src";
          src = pkgs.fetchFromGitHub {
            owner = "NathanChen198";
            repo = "streamlit-cookies-controller";
            rev = "949d52732b95250ffbebef2181d591ea9a4fbdcc";
            sha256 = "sha256-uJk6xKDQ6ACCJ38wTlpe4HtPdECFnkIvLzRJKWnrpqo=";
          };

          installPhase =
            let
              frontend-build =
                let
                  git_src = src;
                in
                pkgs.buildNpmPackage rec {
                  name = "st-cookie-controller-frontend";
                  pname = "st-cookie-controller-frontend";
                  src = "${git_src}/streamlit_cookies_controller/frontend";
                  npmDepsHash = "sha256-zbWpVSYi873lU84J1SG+Zf98Z+ldpA5wAeC8utLtj6s=";
                  NODE_OPTIONS = "--openssl-legacy-provider";
                };
              
            in
            ''
              mkdir -p $out/streamlit_cookies_controller/frontend
              cp $src/streamlit_cookies_controller/*.py $out/streamlit_cookies_controller/
              cp $src/*.py $out/
              cp $src/README.md $out/
              cp $src/MANIFEST.in $out/
              cp -r ${frontend-build}/lib/node_modules/cookie_controller/build $out/streamlit_cookies_controller/frontend
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
          streamlit-cookies-controller = pkgs.python311Packages.buildPythonPackage rec {
            pname = "streamlit-cookies-controller";
            version = "0.1.71";

            propagatedBuildInputs = [ pkgs.python311Packages.streamlit ];

            src = streamlit-cookies-controller-npm-built;
            #doCheck = false; # nicht meine schuld dass deren tests failen
            meta = {
              description = "Control client browser cookie for the site";
              homepage = "https://github.com/NathanChen198/streamlit-cookies-controller";
              license = pkgs.lib.licenses.mit;
            };
          };
        };
      }
    );
}
