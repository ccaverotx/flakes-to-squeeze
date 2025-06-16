{
  description = "NixOS radical + Hyprland + Impermanence + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, impermanence, home-manager, lanzaboote, disko, nixos-wsl, ... }:
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
                home-manager.users.${myUsername} = (import ./modules/home) {
                  inherit impermanence myUsername system;
                  hostname = hostName;
                  lib = nixpkgs.lib;
                  pkgs = nixpkgs.legacyPackages.${system};
                };
              }
            ];
          in
            commonModules ++
              (if hostName == "desktop" then [
                lanzaboote.nixosModules.lanzaboote
                disko.nixosModules.disko
              ] else if hostName == "macbook-pro-2015" then [
                disko.nixosModules.disko
              ] else if hostName == "wsl" then [
                nixos-wsl.nixosModules.wsl
              ] else []);
        specialArgs = {
          inherit impermanence myUsername;
          hostType = hostName;
        };
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem (mkHost "desktop");
        wsl = lib.nixosSystem (mkHost "wsl");
        macbook-pro-2015 = lib.nixosSystem (mkHost "macbook-pro-2015");
      };

      apps.${system} = {
        disko-install-desktop = {
          type = "app";
          program = "${disko.packages.${system}.disko}/bin/disko-install";
        };

        nixos-install-desktop = {
          type = "app";
          program = "${nixpkgs.legacyPackages.${system}.nixos-install}/bin/nixos-install";
        };
      };
    };
}
