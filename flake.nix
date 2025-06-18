{
  description = "NixOS radical + Hyprland + Impermanence + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, impermanence, home-manager,lanzaboote, disko, nixos-wsl, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      myUsername = "ccaverotx";

      # Aquí defines metadatos por host
      hosts = {
        desktop = {
          useLanzaboote = builtins.getEnv "USE_LANZABOOTE" == "1";
          useDisko = true;
          useWSL = false;
        };
        macbook-pro-2015 = {
          useLanzaboote = false;
          useDisko = true;
          useWSL = false;
        };
        wsl = {
          useLanzaboote = false;
          useDisko = false;
          useWSL = true;
        };
      };
      mkHost = hostName: {
        inherit system;
        modules =
          let
            baseModules = [
              ./hosts/${hostName}
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.${myUsername} =
                  import ./modules/home/hosts/${hostName} {
                    inherit impermanence myUsername system;
                    hostType = hostName;
                    lib = nixpkgs.lib;
                    pkgs = nixpkgs.legacyPackages.${system};
                  };
              }
            ];

            optionalModules =
                lib.optionals hosts.${hostName}.useLanzaboote [
                  lanzaboote.nixosModules.lanzaboote
                  ./modules/security/lanzaboote.nix
                ]
                ++ lib.optional hosts.${hostName}.useDisko disko.nixosModules.disko
                ++ lib.optional hosts.${hostName}.useWSL nixos-wsl.nixosModules.wsl;

          in
            baseModules ++ optionalModules;

        specialArgs = {
          inherit impermanence myUsername;
          hostType = hostName;
        };
      };

      mkInstallApps = hostName: {
        "disko-install-${hostName}" = {
          type = "app";
          program = "${disko.packages.${system}.disko}/bin/disko-install";
        };
        "nixos-install-${hostName}" = {
          type = "app";
          program = "${pkgs.nixos-install}/bin/nixos-install";
        };
      };

    in {
      nixosConfigurations =
        lib.mapAttrs (hostName: _: lib.nixosSystem (mkHost hostName)) hosts;

      apps.${system} =
        lib.foldlAttrs (acc: hostName: _: acc // mkInstallApps hostName) {} hosts;
    };
}
