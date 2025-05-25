{ config, pkgs, ... }: {
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
      monitor = [
        "DP-2,1920x1200,0x-350,1,transform,1"
        "DP-1,1920x1080,1200x0,1"
      ];
      workspace = [
        "DP-1,1"
        "DP-2,1"
      ];
      "$mod" = "alt";
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, F, exec, firefox"
        "$mod, C, exec, code"
        "$mod SHIFT, Return, exec, kitty --class=\"termfloat\""
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
      ];
      exec-once = [
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
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
        };
      };
      input.kb_layout = "us";
    };
  };
}
