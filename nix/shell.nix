{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    cowsay
    fzf
    just
    lolcat
    sl
    yq-go
  ];
}
