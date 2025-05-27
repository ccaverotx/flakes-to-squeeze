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
in
{
  inherit colors;

  cursor = {
    name = "Nordzy-cursors-white";
    size = 30;
    package = pkgs.nordzy-cursor-theme;
  };


  gtk = {
    enable = true;
    cursorTheme = {
      name = "Nordzy-cursors-white";
      package = pkgs.nordzy-cursor-theme;
    };
  # Note the different syntax for gtk3 and gtk4
    gtk3.extraConfig = {
      "gtk-cursor-theme-name" = "Nordzy-cursors-white";
    };
    gtk4.extraConfig = {
      Settings = ''
      gtk-cursor-theme-name=Nordzy-cursors-white
      '';
    };
  };

  qt = {
    #platformTheme = "gtk";
    #style = {
    #  name = "Nordic";
    #  package = pkgs.nordic;
    #};
  };

  hyprlandConfig = {
    general = {
      "col.active_border" = "rgb(${builtins.replaceStrings ["#"] [""] colors.base0D})";
      "col.inactive_border" = "rgb(${builtins.replaceStrings ["#"] [""] colors.base03})";
    };

    decoration = {
      rounding = 15;

      blur = {
        enabled = true;
        size = 4;
        passes = 2;
      };
    };
  };
}
