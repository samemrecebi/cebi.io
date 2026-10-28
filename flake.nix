{
  description = "Personal website for Chris Portela";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    hugo-theme-hello-friend-ng = {
      url = "github:rhazdon/hugo-theme-hello-friend-ng";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachSystem
      [
        utils.lib.system.x86_64-darwin
        utils.lib.system.x86_64-linux
        utils.lib.system.aarch64-darwin
        utils.lib.system.aarch64-linux
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {

          packages.website = pkgs.stdenv.mkDerivation {
            name = "website";
            src = self;
            buildInputs = with pkgs; [
              git
              prettier
            ];
            buildPhase = ''
              mkdir -p themes
              ln -s ${inputs.hugo-theme-hello-friend-ng} themes/hello-friend-ng
              ${pkgs.hugo}/bin/hugo build
              ${pkgs.prettier}/bin/prettier -w public '!**/*.{js,css}'
            '';
            installPhase = "cp -r public $out";
          };

          defaultPackage = self.packages.${system}.website;

          apps = rec {
            hugo = utils.lib.mkApp { drv = pkgs.hugo; };
            default = hugo;
          };

          devShell = pkgs.mkShellNoCC {
            packages = with pkgs; [
              prettier
              hugo
              marksman
            ];
            shellHook = ''
              mkdir -p themes
              ln -snf "${inputs.hugo-theme-hello-friend-ng}" themes/hello-friend-ng
            '';
          };

        }
      );
}
