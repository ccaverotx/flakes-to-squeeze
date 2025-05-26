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
    #theme = {
    #  name = "Nordic";
    #  package = pkgs.nordic;
    #};
    #iconTheme = {
    #  name = "Papirus-Dark";
    #  package = pkgs.papirus-icon-theme;
    #};
    cursorTheme = {
      name = "Nordzy-cursors-white";
      package = pkgs.nordzy-cursor-theme;
      size = 30;
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
