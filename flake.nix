{
  description = "NixOS radical + Hyprland + Impermanence + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Asegura que home-manager use el mismo nixpkgs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, impermanence, home-manager, lanzaboote, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      myUsername = "ccaverotx";
    in {
      # Configuración del sistema
      nixosConfigurations.desktop = lib.nixosSystem {
        inherit system;
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./hosts/desktop
          home-manager.nixosModules.home-manager
          
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${myUsername} = import ./modules/home;
          }
        ];

        specialArgs = {
          inherit impermanence myUsername;
        };
      };

      ## Configuración Home Manager standalone (por si lo ejecutas directamente)
      homeConfigurations.${myUsername} = home-manager.lib.homeManagerConfiguration {
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [
          ./modules/home
        ];
        extraSpecialArgs = {
          inherit myUsername;
        };
      };

    };
}
