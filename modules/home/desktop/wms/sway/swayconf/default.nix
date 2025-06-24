{ config, pkgs, ... }:

let
  modifier = "Mod1"; # Alt key
  terminal = "kitty";
  menu = "wofi --show run";
in
{
  modifier = modifier;
  terminal = terminal;
  menu = menu;

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

  output = {
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
  };
}
