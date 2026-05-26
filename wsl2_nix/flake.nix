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
        Cambrian = "test";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.bash-language-server
            pkgs.fish
            pkgs.ghq
            pkgs.git
            pkgs.go-task
            pkgs.lazygit
            pkgs.neovim
            pkgs.nodejs_24
            pkgs.tmux
            pkgs.zip
          ];

          shellHook = ''
            echo "Nix のシェルに接続しました"
          '';
        };
      }
    );
}
