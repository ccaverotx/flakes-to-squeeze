{ config, lib, pkgs, ... }:

{
  options.hyprlandTheme.active = lib.mkOption {
    type = lib.types.str;
    default = "nord";
    description = "Tema activo para Hyprland";
  };

  imports = [
    ./hyprconf/bindings.nix
    ./hyprconf/monitor.nix
    ./themes
  ];

  config = {
    home.packages = [
      (pkgs.writeShellScriptBin "hyprland" ''
        export HYPRLAND_CONFIG=${config.home.homeDirectory}/.config/hypr/hyprland.conf
        exec ${pkgs.hyprland}/bin/Hyprland
      '') 
      pkgs.waybar
      pkgs.rofi
      pkgs.mako
      pkgs.swww
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.swappy
      pkgs.hyprpolkitagent
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      systemd.enable = true;
      systemd.variables = [ "--all" ];

      settings = {
        exec-once = [
          # TODO: hardcoded cursor
          "hyprctl setcursor Nordzy-cursors-white 30"
          "dbus-update-activation-environment --systemd --all"
          "nm-applet --indicator"
          "waybar"
          "mako"
        ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          layout = "dwindle";
        };
        
        input.kb_layout = "us";
      };
    };
  };
}
