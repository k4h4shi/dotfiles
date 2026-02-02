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

      # 環境変数から動的に取得（--impure フラグが必要）
      currentUser = builtins.getEnv "USER";
      currentHome = builtins.getEnv "HOME";
      currentSystem = builtins.currentSystem;

      # ユーザー名が取得できない場合のフォールバック
      username = if currentUser != "" then currentUser else "default";
      homeDirectory = if currentHome != "" then currentHome else "/home/${username}";

      # home-manager設定を生成する関数
      mkHomeConfig = { system, user, home }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./modules/home.nix ];
          extraSpecialArgs = {
            username = user;
            homeDirectory = home;
          };
        };
    in
    {
      homeConfigurations = {
        # 動的設定（現在のユーザー用）
        "${username}" = mkHomeConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
        };

        # デフォルト設定（動的設定と同じ）
        "default" = mkHomeConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
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
