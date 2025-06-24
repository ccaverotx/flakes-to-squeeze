{ config, pkgs, ... }:

let
  hostType = config.hostType;
  modifier = "Mod1";
  bar = "waybar";
  terminal = "kitty";
  menu = "wofi --show run";
in

builtins.trace ">>> hostType dentro de swayconf/default.nix: ${hostType}" {

  modifier = modifier;
  terminal = terminal;
  menu = menu;
  bars = [];

  input = {
    "*" = {
      xkb_layout = "latam";
      xkb_options = "lv3:ralt_switch";
    };
  };

  keybindings = {
    "${modifier}+Return" = "exec ${terminal}";
    "${modifier}+Q" = "kill";
    "${modifier}+D" = "exec ${menu}";
    "${modifier}+Shift+E" = "exec swaymsg exit";

    "${modifier}+F1" = "exec firefox";
    "${modifier}+F2" = "exec code";
    "${modifier}+F3" = "exec thunar";
    "${modifier}+F4" = "exec pavucontrol";
  };

  output = if hostType == "macbook-pro-2015" then {
    "eDP-1" = {
      pos = "0 0";
      res = "2880x1800";
      scale = "2.0";
      bg = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath} fill";
    };
  } else if hostType == "desktop" then {
    "DP-1" = {
      pos = "0 0";
      res = "1920x1080";
      scale = "1.0";
      bg = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath} fill";
    };
    "DP-2" = {
      pos = "1920 0";
      res = "1200x1920";
      transform = "90";
      scale = "1.0";
      bg = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath} fill";
    };
  } else 
    builtins.trace "⚠️ hostType desconocido para configuración de outputs: ${hostType}" {};

  startup = [
    { command = bar; always = true; }
  ];
}
