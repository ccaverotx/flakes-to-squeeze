{ config, pkgs, impermanence, ... }:

{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/hyprland.nix
    ../../modules/security/polkit.nix
    ../../hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  programs.hyprland.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.displayManager.defaultSession = "hyprland";

  services.getty.autologinUser = "ccaverotx";

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    pantheon.pantheon-agent-polkit
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
