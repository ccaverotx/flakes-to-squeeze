{ pkgs, lib, hostType, ... }:

builtins.trace ">>> Host recibido en home/hosts/desktop: ${hostType}" (

let
  theme = "nord"; # 👈 Valor del tema activo para este host
in

builtins.trace ">>> Tema activo en home/hosts/desktop: ${theme}" (

  assert hostType == "desktop";

  {
    imports = [
      ../../globals/host-type.nix
      ../../globals/global-theme.nix
      ../../programs/gui-apps/firefox
      ../../programs/gui-apps/dbeaver
      ../../programs/gui-apps/vscode
      ../../programs/gui-apps/kitty
      ../../programs/gui-apps/nemo
      ../../programs/gui-apps/zoom
      ../../programs/tui-apps/yazi
      ../../programs/tui-apps/qutebrowser
      ../../desktop/wms/hyprland
      ../../desktop/wms/hyprland/xdg.nix
    ];

    home.username = "ccaverotx";
    home.homeDirectory = lib.mkForce "/home/ccaverotx";
    home.stateVersion = "24.05";

    hostType = hostType;
    hyprlandTheme.active = theme;

    home.packages = with pkgs; [
      unzip
      udiskie
      devenv
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
