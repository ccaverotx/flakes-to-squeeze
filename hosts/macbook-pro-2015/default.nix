{ config, pkgs, lib, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/security/polkit.nix
    ../../modules/services/podman
    ../../modules/services/greetd
    ../../modules/home/desktop/wms/sway/system.nix
    ../../hardware-configuration.nix
    ../../hosts/macbook-pro-2015/disko.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/sensors.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/brightness.nix
    ../../modules/services/tlp
    ../../modules/services/mbpfan
  ];

  networking.hostName = "macbook-pro-2015";
  networking.hostId = "deadbeef";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.sway.enable = true;
  greetd.enableSwaySession = true;
  
  virtualisation.podman.enable = true;

  # Conservamos las utils aquí de momento
  environment.systemPackages = with pkgs; [
    unzip
    htop
    pciutils
    usbutils
    wev
  ];

  # Necesario para que impermanence funcione correctamente
  fileSystems."/persist".neededForBoot = lib.mkForce true;
}
