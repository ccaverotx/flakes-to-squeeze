{ config, pkgs, ... }: {
  home.username = "ccaverotx";
  home.homeDirectory = "/home/ccaverotx";
  home.stateVersion = "24.05";

  home.packages = [ 
    pkgs.home-manager 
    pkgs.unzip 
    pkgs.udiskie 
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.dejavu-sans-mono
    pkgs.font-awesome
    ];


  imports = [
    ./programs/gui-apps/firefox
    ./programs/gui-apps/vscode
    ./programs/gui-apps/kitty
    ./programs/gui-apps/nemo
    ./programs/tui-apps/yazi
    ./desktop/wms/hyprland
    ./services/polkit.nix
    ./desktop/wms/hyprland/xdg.nix
  ];
}
