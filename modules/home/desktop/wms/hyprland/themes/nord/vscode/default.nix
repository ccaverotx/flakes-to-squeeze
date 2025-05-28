{ pkgs, ... }:

{
  vscode = {
    extension = pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code;
    settings = {
      "workbench.colorTheme" = "Nord";
      # Puedes agregar más configuraciones si quieres
    };
  };
}
