{ config, pkgs, lib, ... }:

{
  options = {
    secureboot.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Secure Boot using lanzaboote";
    };
  };

  config = lib.mkIf (config.secureboot.enable && lib.hasAttrByPath [ "boot" "lanzaboote" ] config) {
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl/";
    };
  };
}
