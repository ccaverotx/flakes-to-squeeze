{ config, pkgs, lib, impermanence, ... }:

let
  ## Cargar directamente el tema activo
  #activeTheme = import ../../modules/home/desktop/wms/hyprland/themes/nord {
  #  inherit config pkgs lib;
  #};

  #cursorName = activeTheme.cursor.name;
  #cursorSize = toString activeTheme.cursor.size;
in
{
  imports = [
    ../default.nix
    ../../modules/impermanence.nix
    ../../modules/hyprland.nix
    ../../modules/security/lanzaboote.nix
    ../../modules/security/polkit.nix
    ../../modules/services/podman
    ../../hardware-configuration.nix
  ];

  networking.hostName = "desktop";

  programs.hyprland.enable = true;

  #TODO: Find a way to improve this
  #Needed: hyprctl setcursor Nordzy-cursors-white 30
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
    postgresql
  ];

  secureboot.enable = true;

  virtualisation.podman.enable = true;

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}