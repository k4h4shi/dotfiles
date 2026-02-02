{
  description = "k4h4shi's dotfiles managed by nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }:
    let
      # サポートするシステム
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      currentSystem = builtins.currentSystem;

      # 現在のシステムがmacOSかどうか
      isDarwin = builtins.elem currentSystem darwinSystems;

      # 環境変数から動的に取得（--impure フラグが必要）
      # NOTE: sudo で実行する場合、HOME/USER を偽装すると nix が警告するため、
      #       インストーラから明示的に渡す DOTFILES_* を優先して使う。
      envUser = builtins.getEnv "DOTFILES_USERNAME";
      envHome = builtins.getEnv "DOTFILES_HOME";
      currentUser = if envUser != "" then envUser else builtins.getEnv "USER";
      currentHome = if envHome != "" then envHome else builtins.getEnv "HOME";

      # ユーザー名が取得できない場合のフォールバック
      username = if currentUser != "" then currentUser else "default";
      defaultHomeDirectory =
        if isDarwin
        then "/Users/${username}"
        else "/home/${username}";
      homeDirectory = if currentHome != "" then currentHome else defaultHomeDirectory;

      # macOS用: nix-darwin + home-manager 統合設定を生成
      mkDarwinConfig = { system, user, home, profile ? "personal" }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            username = user;
            homeDirectory = home;
            inherit profile;
          };
          modules = [
            ./modules/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # 既存ファイルを home-manager 管理ファイルで置き換える際に自動バックアップする
              # 例: settings.json -> settings.json.backup
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                username = user;
                homeDirectory = home;
              };
              home-manager.users.${user} = import ./modules/home.nix;
              users.users.${user}.home = home;
            }
          ];
        };

      # Linux用: home-manager standalone
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
      # macOS用: nix-darwin設定
      darwinConfigurations = {
        # 個人用（デフォルト）: 共通 + 音楽制作アプリ
        "personal" = mkDarwinConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
          profile = "personal";
        };

        # 共通: 最小限のアプリのみ
        "common" = mkDarwinConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
          profile = "common";
        };

        # デフォルト（personal と同じ）
        "default" = mkDarwinConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
          profile = "personal";
        };
      };

      # Linux用: home-manager設定（macOS以外で使う場合）
      homeConfigurations = {
        "${username}" = mkHomeConfig {
          system = currentSystem;
          user = username;
          home = homeDirectory;
        };

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
            ];
            shellHook = ''
              echo "dotfiles dev shell"
              echo "  - nil: Nix LSP"
              echo "  - nixpkgs-fmt: formatter"
              echo "  - home-manager: use 'nix run home-manager -- <command>'"
            '';
          };
        }
      );
    };
}
