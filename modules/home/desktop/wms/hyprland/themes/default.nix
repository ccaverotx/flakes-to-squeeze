{ config, pkgs, lib, ... }:

let
  themeName = config.hyprlandTheme.active;
  availableThemes = {
    nord = import ./nord { inherit config pkgs lib; };
  };
  activeTheme = lib.attrByPath [ themeName ] null availableThemes;
in
{
  config = lib.mkIf (activeTheme != null) {
    home.packages = [
      activeTheme.cursor.package
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = activeTheme.cursor.name;
      package = activeTheme.cursor.package;
      size = activeTheme.cursor.size or 24;
    };

    gtk.cursorTheme = {
      name = activeTheme.gtk.cursorTheme.name;
      package = activeTheme.gtk.cursorTheme.package;
      size = activeTheme.gtk.cursorTheme.size;
    };

    qt = activeTheme.qt;

    wayland.windowManager.hyprland.settings = activeTheme.hyprlandConfig or {};

    programs.waybar = {
      enable = true;
      settings = [ activeTheme.waybarConfig ];
      style = activeTheme.waybarStyle;
    };
  };
}
