{
  description = "NixOS radical + Hyprland + Impermanence + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, impermanence, home-manager, lanzaboote, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      myUsername = "ccaverotx";

      mkHost = hostName: {
        inherit system;
        modules =
          let
            commonModules = [
              ./hosts/${hostName}
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.${myUsername} = import ./modules/home;
              }
            ];
          in
            commonModules ++
              (if hostName == "desktop" then [ lanzaboote.nixosModules.lanzaboote ] else []);
        specialArgs = {
          inherit impermanence myUsername;
          hostType = hostName;
        };
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem (mkHost "desktop");
        wsl = lib.nixosSystem (mkHost "wsl");
      };

      homeConfigurations.${myUsername} = home-manager.lib.homeManagerConfiguration {
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [ ./modules/home ];
        extraSpecialArgs = { inherit myUsername; };
      };
    };
}
