{ config, lib, pkgs, ... }:

let
  hostname = config.networking.hostName or "unknown";
  hostType =
    if hostname == "macbook-pro-2015" then "laptop"
    else if hostname == "desktop" then "desktop"
    else "unknown";

  isHiDPI = hostType == "laptop"; # o ajusta según lo necesites
in {
  options.hyprlandSystem.enable = lib.mkEnableOption "Enable Hyprland system-level configuration";

  config = lib.mkIf config.hyprlandSystem.enable {
    programs.hyprland.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
          user = "ccaverotx";
        };
      };
    };

    environment.sessionVariables =
      {
        XCURSOR_THEME = "Nordzy-cursors-white";
        XCURSOR_SIZE = "30";
        ELECTRON_ENABLE_HIGH_DPI_SCALING = "1";
      }
      // lib.optionalAttrs isHiDPI {
        GDK_SCALE = "2";
        ELECTRON_FORCE_DEVICE_SCALE_FACTOR = "2";
      };

    environment.systemPackages = with pkgs; [
      greetd.tuigreet
      pantheon.pantheon-agent-polkit
    ];
  };
}
