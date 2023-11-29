{
  # See https://github.com/mhwombat/nix-for-numbskulls/blob/main/flakes.md
  # for a brief overview of what each section in a flake should or can contain.

  description = "a very simple and friendly flake written in Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
      in
      {

        packages = rec {

          scenedetect = python.pkgs.buildPythonApplication {
            name = "scenedetect";
            version = "0.6.2";
            src = fetchTarball {
              url = https://github.com/Breakthrough/PySceneDetect/archive/refs/tags/v0.6.2-release.tar.gz;
              sha256 = "sha256:0hfxsnzf6ip19jclx504x85yygj34dbfnn1wa2rh2pwxrc1bsapm";
            };
            propagatedBuildInputs = (with python.pkgs; [
              scikit-build
              opencv4
              click
              platformdirs
            ]) ++ [ pkgs.ffmpeg ];
            doCheck = false;
          };
          default = scenedetect;
        };

        apps = rec {
          scenedetect = flake-utils.lib.mkApp { drv = self.packages.${system}.scenedetect; };
          default = scenedetect;
        };
      }
    );
}

