{ pkgs, ... }: {
  home.packages = [
    pkgs.vscode
    pkgs.vscode-extensions.jnoortheen.nix-ide
    pkgs.vscode-extensions.emmanuelbeziat.vscode-great-icons
    pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
  ];

  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.emmanuelbeziat.vscode-great-icons
      pkgs.vscode-extensions.arcticicestudio.nord-visual-studio-code
    ];
    profiles.default.userSettings = {
      "workbench.colorTheme" = "Nord";
    };
  };
}
