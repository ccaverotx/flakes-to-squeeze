{ config, pkgs, lib, ... }:

let
  hostType = config.hostType;
  cursorSize = if hostType == "macbook-pro-2015" then 48 else 24;
in
{
  home.pointerCursor = {
    name = "Adwaita";
    size = cursorSize;
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = toString cursorSize;
  };
}
