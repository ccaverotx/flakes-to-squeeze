#{ config, lib, pkgs, ... }:
#
#let
#  hostType = config.hostType;
#in
#
#{
#  imports = [
#    ./hyprconf/bindings.nix
#    ./hyprconf/monitor.nix
#    ./themes
#  ];
#
#  config = {
#    home.packages = [
#      (pkgs.writeShellScriptBin "hyprland" ''
#        export HYPRLAND_CONFIG=${config.home.homeDirectory}/.config/hypr/hyprland.conf
#        exec ${pkgs.hyprland}/bin/Hyprland
#      '') 
#      pkgs.waybar
#      pkgs.rofi-wayland
#      pkgs.mako
#      pkgs.swww
#      pkgs.grim
#      pkgs.slurp
#      pkgs.wl-clipboard
#      pkgs.swappy
#      pkgs.hyprpolkitagent
#    ];
#
#    systemd.user.services.polkit-pantheon-authentication-agent-1 = {
#      Unit = {
#        Description = "Pantheon Polkit Authentication Agent";
#        After = [ "graphical-session.target" ];
#      };
#      Service = {
#        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
#        Restart = "on-failure";
#      };
#      Install = {
#        WantedBy = [ "graphical-session.target" ];
#      };
#    };
#
#    wayland.windowManager.hyprland = builtins.trace ">>> hostType desde config.hostType: ${hostType}" {
#      enable = true;
#      package = null;
#      systemd.enable = true;
#      systemd.variables = [ "--all" ];
#
#      settings = {
#        exec-once = [
#          "hyprctl setcursor Nordzy-cursors-white 30"
#          "dbus-update-activation-environment --systemd --all"
#          "nm-applet --indicator"
#          "waybar"
#          "mako"
#        ];
#
#        general = {
#          gaps_in = 4;
#          gaps_out = 8;
#          border_size = 2;
#          layout = "dwindle";
#        };
#
#        input.kb_layout = "us";
#      };
#    };
#  };
#}
