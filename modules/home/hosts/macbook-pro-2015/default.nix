{ config, lib, pkgs, ... }:

{
  home.username = "ccaverotx";
  home.homeDirectory = lib.mkForce "/home/ccaverotx";
  home.stateVersion = "24.05";
  
  imports = [
    ../../desktop/wms/hyprland
    ../../desktop/wms/hyprland/xdg.nix
    ../../programs/gui-apps/firefox
    ../../programs/gui-apps/kitty
    ../../programs/gui-apps/vscode
    ../../programs/gui-apps/nemo
    ../../programs/tui-apps/yazi
    ../../programs/tui-apps/qutebrowser
  ];

  home.packages = with pkgs; [
    unzip
    udiskie
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.noto
    nerd-fonts.dejavu-sans-mono
    font-awesome
  ];
}
