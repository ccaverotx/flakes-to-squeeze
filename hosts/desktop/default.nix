{ config, pkgs, lib, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/hyprland.nix
    #../../modules/security/lanzaboote.nix
    ../../modules/security/polkit.nix
    ../../modules/services/podman
    ../../hardware-configuration.nix
    ../../hosts/desktop/disko.nix
  ];

  networking.hostName = "desktop";
  networking.hostId = "deadbeef";


  programs.hyprland.enable = true;

  environment.sessionVariables = {
    XCURSOR_THEME = "Nordzy-cursors-white";
    XCURSOR_SIZE = "30";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.displayManager.defaultSession = "hyprland";

  services.getty.autologinUser = "ccaverotx";

  environment.systemPackages = with pkgs; [
    pantheon.pantheon-agent-polkit
    postgresql
  ];

  #secureboot.enable = true;

  virtualisation.podman.enable = true;


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/etc/nixos" = {
    device = "zroot/nixos/persist/etc-nixos";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

   fileSystems."/persist" = {
    device = "zroot/nixos/persist";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/persist/var" = {
    device = "zroot/nixos/persist/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/persist/home" = {
    device = "zroot/nixos/persist/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/persist/home/ccaverotx" = {
    device = "zroot/nixos/persist/home/ccaverotx";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };
}
