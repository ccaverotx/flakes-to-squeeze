{ config, lib, pkgs, ... }:

let
  themeName = config.hyprlandTheme.active;

  themeExtensions = {
    nord = {
      extension = pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code;
      name = "Nord";
    };
    catppuccin = {
      extension = pkgs.vscode-extensions.catppuccin.catppuccin-vsc or null;
      name = "Catppuccin Macchiato";
    };
    # Puedes agregar más temas aquí
  };

  theme = lib.attrByPath [ themeName ] null themeExtensions;
in

{
  config = lib.mkIf (theme != null) {
    home.packages = [
      pkgs.vscode
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.emmanuelbeziat.vscode-great-icons
      theme.extension
    ];

    programs.vscode = {
      enable = true;
      extensions = [
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.emmanuelbeziat.vscode-great-icons
        theme.extension
      ];
      profiles.default.userSettings = {
        "workbench.colorTheme" = theme.name;
      };
    };
  };
}
