{ config, pkgs, lib, impermanence, ... }:

let
  # Cargar directamente el tema activo
  activeTheme = import ../../modules/home/desktop/wms/hyprland/themes/nord {
    inherit config pkgs lib;
  };

  cursorName = activeTheme.cursor.name;
  cursorSize = toString activeTheme.cursor.size;
in
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

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    pantheon.pantheon-agent-polkit
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
