{ config, lib, pkgs, ... }:

let
  colors = {
    base00 = "#2E3440";
    base01 = "#3B4252";
    base02 = "#434C5E";
    base03 = "#4C566A";
    base04 = "#D8DEE9";
    base05 = "#E5E9F0";
    base06 = "#ECEFF4";
    base07 = "#8FBCBB";
    base08 = "#88C0D0";
    base09 = "#81A1C1";
    base0A = "#5E81AC";
    base0B = "#BF616A";
    base0C = "#D08770";
    base0D = "#EBCB8B";
    base0E = "#A3BE8C";
    base0F = "#B48EAD";
  };

  waybarTheme = import ./waybar { inherit config lib pkgs; };
  kitty = import ./kitty { inherit config pkgs lib; };
  vscode = (import ./vscode { inherit config pkgs lib; }).vscode;
  rofi = import ./rofi/default.nix { inherit config pkgs lib; };

in
{
  inherit colors;
  inherit rofi;
  cursor = {
    name = "Nordzy-cursors-white";
    size = 30;
    package = pkgs.nordzy-cursor-theme;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };

    cursorTheme = {
      name = "Nordzy-cursors-white";
      package = pkgs.nordzy-cursor-theme;
      size = 30;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = "true";
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=true
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  hyprlandConfig = {
    general = {
      "col.active_border" = "rgb(${builtins.replaceStrings ["#"] [""] colors.base0A})";
      "col.inactive_border" = "rgb(${builtins.replaceStrings ["#"] [""] colors.base03})";
    };

    decoration = {
      rounding = 4;
      active_opacity = 0.95;
      inactive_opacity = 0.85;
      fullscreen_opacity = 1.0;

      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        new_optimizations = true;
        xray = true;
        ignore_opacity = false;
      };

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        ignore_window = true;
        color = "0x1a1a1aee";
      };
      
      dim_inactive = false;
    };
  };

  waybarConfig = waybarTheme.config.waybarConfig;
  waybarStyle = waybarTheme.config.waybarStyle;

  kitty = kitty;
  
  vscode = vscode;

  #rofi = {
  #  theme = {
  #    content = builtins.readFile ./rofi/config.nix;
  #  };
  #};

  
}
