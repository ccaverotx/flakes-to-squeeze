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
      activeTheme.gtk.theme.package
      activeTheme.gtk.iconTheme.package
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = activeTheme.cursor.name;
      package = activeTheme.cursor.package;
      size = activeTheme.cursor.size or 24;
    };

    gtk = {
      enable = true;
      
      cursorTheme = {
        name = activeTheme.gtk.cursorTheme.name;
        package = activeTheme.gtk.cursorTheme.package;
        size = activeTheme.gtk.cursorTheme.size;
      };
      theme = {
        name = activeTheme.gtk.theme.name;
        package = activeTheme.gtk.theme.package;
      };
      iconTheme = {
        name = activeTheme.gtk.iconTheme.name;
        package = activeTheme.gtk.iconTheme.package;
      };
      gtk3.extraConfig = activeTheme.gtk.gtk3.extraConfig or { };
      gtk4.extraConfig = activeTheme.gtk.gtk4.extraConfig or { };
    };

    qt = activeTheme.qt;

    wayland.windowManager.hyprland.settings = activeTheme.hyprlandConfig or {};

    programs.waybar = {
      enable = true;
      settings = [ activeTheme.waybarConfig ];
      style = activeTheme.waybarStyle;
    };

    programs.kitty = {
      enable = true;
      extraConfig = activeTheme.kitty.theme.content;
    };

    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = [ activeTheme.vscode.extension ];
        userSettings = activeTheme.vscode.settings;
      };
    };
  };
}
