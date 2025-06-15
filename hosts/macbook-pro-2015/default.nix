{ config, pkgs, lib, impermanence, ... }: {
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/security/polkit.nix
    ../../hardware-configuration.nix
  ];

  networking.hostName = "macbook-pro-2015";
  networking.hostId = "cafebabe"; # cámbialo si tienes conflictos

  time.timeZone = "America/La_Paz";
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland";

  services.getty.autologinUser = "ccaverotx";

  environment.systemPackages = with pkgs; [
    pantheon.pantheon-agent-polkit
  ];

  secureboot.enable = false;

  # File systems, adapt based on your setup (ZFS, ext4, etc)
}
