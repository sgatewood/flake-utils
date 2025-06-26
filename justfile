help:
  @just -l

run-update:
  nix run .#pkgVersionSnapshotTest

diff-closures:
  #!/usr/bin/env bash
  nix store diff-closures \
    '.?ref=origin/main#.devShells.aarch64-darwin.default' \
    '.?ref=HEAD#.devShells.aarch64-darwin.default'
