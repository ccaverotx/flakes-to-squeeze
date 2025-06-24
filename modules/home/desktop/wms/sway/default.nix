{ config, pkgs, lib, ... }:

{
  imports = [
    ./xdg.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = import ./swayconf { inherit config pkgs; };
    extraOptions = [];
  };

  # Utilidades complementarias (puedes ajustar o eliminar luego)
  programs.waybar.enable = true;
  programs.rofi.enable = true;
  services.mako.enable = true;
}
