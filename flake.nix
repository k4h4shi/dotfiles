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
            homeDirectory = "$HOME";
          };
        };

        # 汎用設定（新しいマシン用）
        "default" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./modules/home.nix ];
          extraSpecialArgs = {
            username = builtins.getEnv "USER";
            homeDirectory = builtins.getEnv "HOME";
          };
        };
      };
    };
}
