{ pkgs, lib, hostType, ... }:

builtins.trace ">>> Host recibido en home/hosts/macbook-pro-2015: ${hostType}" (

let
  theme = "nord"; # 👈 Valor del tema activo para este host
in

builtins.trace ">>> Tema activo en home/hosts/macbook-pro-2015: ${theme}" (

  assert hostType == "macbook-pro-2015";

  {
    imports = [
      ../../globals/host-type.nix
      ../../globals/global-theme.nix
      ../../programs/gui-apps/firefox
      ../../programs/gui-apps/vscode
      ../../programs/gui-apps/kitty
      ../../programs/gui-apps/nemo
      ../../programs/tui-apps/yazi
      #../../programs/tui-apps/qutebrowser
      ../../desktop/wms/sway
      ../../desktop/cursor
    ];

    home.username = "ccaverotx";
    home.homeDirectory = lib.mkForce "/home/ccaverotx";
    home.stateVersion = "24.05";

    hostType = hostType;
    #hyprlandTheme.active = theme;

    home.packages = with pkgs; [
      unzip
      udiskie
      distrobox
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.noto
      nerd-fonts.dejavu-sans-mono
      font-awesome
    ];
  }
))
