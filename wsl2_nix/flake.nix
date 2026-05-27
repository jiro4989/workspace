{
  description = "開発環境";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # 複数のシステム(Linux, Macなど)に簡単に対応するためのライブラリ
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bash-language-server
            pkgs.deno
            pkgs.fish
            pkgs.fzf
            pkgs.ghq
            pkgs.git
            pkgs.go
            pkgs.go-task
            pkgs.lazygit
            pkgs.neovim
            pkgs.nim
            pkgs.nodejs_24
            pkgs.zellij
            pkgs.zip
          ];

          shellHook = ''
            exec zellij
          '';
        };
      }
    );
}
