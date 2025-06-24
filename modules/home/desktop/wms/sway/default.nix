{ config, pkgs, lib, ... }:

let
  hostType = config.hostType;
in
{
  imports = [
    ./xdg.nix
  ];

  wayland.windowManager.sway = builtins.trace ">>> hostType desde sway: ${hostType}" {
    enable = true;
    config = import ./swayconf { inherit config pkgs; };
    extraOptions = [];
  };

  programs.waybar.enable = true;
  programs.rofi.enable = true;
  services.mako.enable = true;
}
