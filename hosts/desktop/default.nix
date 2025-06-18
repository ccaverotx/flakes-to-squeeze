{ config, pkgs, lib, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    #../../modules/security/lanzaboote.nix
    ../../modules/security/polkit.nix
    ../../modules/security/secure-boot.nix
    ../../modules/services/podman
    ../../modules/home/desktop/wms/hyprland/system.nix
    ../../modules/file-systems/zfs.nix
    ../../hardware-configuration.nix
    ../../hosts/desktop/disko.nix
  ];

  networking.hostName = "desktop";
  networking.hostId = "deadbeef";

  hyprlandSystem.enable = true;

  secureBoot.enable = true;
  virtualisation.podman.enable = true;

  file-systems.zfs.enable = true;

  environment.systemPackages = with pkgs; [
    postgresql
  ];
}
