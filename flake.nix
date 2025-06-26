{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
        devShell = import ./nix/shell.nix {
          inherit pkgs;
        };
        pkgVersionSnapshotTest = (import ./nix/lib/index.nix).pkgVersionSnapshotTest {
          inherit pkgs;
          inherit devShell;
          snapshotFileName = "flake.lock.pkgs.yaml";
        };
      in
      {
        devShells.default = devShell;
        formatter = treefmtEval.config.build.wrapper;
        checks.formatting = treefmtEval.config.build.check self;
        checks.pkgVersionSnapshotTest = pkgVersionSnapshotTest.check;
        apps.pkgVersionSnapshotTest = pkgVersionSnapshotTest.updateApp;
      }
    );
}
