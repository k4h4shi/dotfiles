{
  description = "k4h4shi's dotfiles managed by home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # サポートするシステム
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      homeConfigurations = {
        # macOS (Apple Silicon)
        "takahashikotaro" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./modules/home.nix ];
          extraSpecialArgs = {
            username = "takahashikotaro";
            homeDirectory = "/Users/takahashikotaro";
          };
        };

        # デフォルト設定（takahashikotaro と同じ）
        "default" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./modules/home.nix ];
          extraSpecialArgs = {
            username = "takahashikotaro";
            homeDirectory = "/Users/takahashikotaro";
          };
        };
      };

      # 開発シェル（このリポジトリの編集用）
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil              # Nix LSP
              nixpkgs-fmt      # Nixフォーマッタ
              home-manager     # home-manager CLI
            ];
            shellHook = ''
              echo "dotfiles dev shell"
              echo "  - nil: Nix LSP"
              echo "  - nixpkgs-fmt: formatter"
              echo "  - home-manager: CLI"
            '';
          };
        }
      );
    };
}
