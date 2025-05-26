{ config, pkgs, ... }: {
  home.username = "ccaverotx";
  home.homeDirectory = "/home/ccaverotx";
  home.stateVersion = "24.05";

  home.packages = [ pkgs.home-manager pkgs.unzip ];

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
