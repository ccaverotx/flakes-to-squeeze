{ config, pkgs, lib, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/security/polkit.nix
    ../../modules/services/podman
    ../../modules/home/desktop/wms/hyprland/system.nix
    #../../modules/file-systems/btrfs.nix
    ../../hardware-configuration.nix
    ../../hosts/macbook-pro-2015/disko.nix
  ];

  networking.hostName = "macbook-pro-2015";
  networking.hostId = "slimboi";

  hyprlandSystem.enable = true;

  virtualisation.podman.enable = true;
  #file-systems.btrfs.enable = true;

  environment.systemPackages = with pkgs; [
    postgresql
  ];
}
