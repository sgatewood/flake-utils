{
  pkgs,
  devShell,
  snapshotFileName,
  snapshotFileDir,
}:
let
  toolsMeta = (import ./dev-shell-to-tools-meta.nix) devShell;
  expectedYaml = pkgs.lib.generators.toYAML { } toolsMeta;
  expectedFile = pkgs.writeText "expected.yaml" expectedYaml;
  updateScript = pkgs.writeShellApplication {
    name = "update-flake-lock-pkgs-yaml";
    text = ''
      set -euo pipefail
      yq -P ${expectedFile} > ${snapshotFileName}
    '';
  };
in
{
  check =
    pkgs.runCommandLocal "pkgVersionSnapshotTest"
      {
        src = snapshotFileDir;
        nativeBuildInputs = with pkgs; [
          diffutils
          yq-go
        ];
      }
      ''
        if ! diff -u --color <(yq -P "$src/${snapshotFileName}") <(yq -P "${expectedFile}"); then
          echo "^^ snapshot is out of date"
          exit 1
        fi
        mkdir "$out"
      '';
  updateApp = {
    type = "app";
    program = "${updateScript}/bin/${updateScript.name}";
  };
}
