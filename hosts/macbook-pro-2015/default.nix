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

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp.enable = true;

  hardware.sensor.iio.enable = true;
  hardware.lm-sensors.enable = true;

  services.mbpfan = {
    enable = true;
    settings.general = {
      verbose = true;
      log_level = 2;
      daemon = true;
    };
  };

  environment.systemPackages = with pkgs; [
    postgresql

    # Red
    networkmanager
    networkmanagerapplet

    # Gestión térmica
    mbpfan

    # Brillo y retroiluminación
    brightnessctl
    acpilight

    # Sensores y energía
    tlp
    acpi
    lm_sensors

    # Audio
    pulseaudio

    # Bluetooth
    bluez
    bluez-tools
    blueman

    # Utilidades generales
    unzip
    htop
    pciutils
    usbutils
  ];

  # Necesario para que impermanence funcione correctamente
  fileSystems."/persist".neededForBoot = lib.mkForce true;
}
