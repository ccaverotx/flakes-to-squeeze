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
    checkConfig = false;
    package = pkgs.swayfx;
    config = import ./swayconf { inherit config pkgs; };
    extraOptions = [];
  };

  programs.rofi.enable = true;
  services.mako.enable = true;
}
