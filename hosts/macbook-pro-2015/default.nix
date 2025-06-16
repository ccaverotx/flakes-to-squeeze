{ config, pkgs, lib, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/security/polkit.nix
    ../../modules/services/podman
    ../../modules/home/desktop/wms/hyprland/system.nix
    ../../hardware-configuration.nix
    ../../hosts/macbook-pro-2015/disko.nix
  ];

  networking.hostName = "macbook-pro-2015";
  networking.hostId = "deadbeef";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hyprlandSystem.enable = true;
  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    postgresql
  ];

  # Necesario para que impermanence funcione correctamente
  fileSystems."/persist".neededForBoot = lib.mkForce true;
}
