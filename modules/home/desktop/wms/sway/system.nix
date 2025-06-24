{ config, lib, pkgs, ... }:

let
  hostname = config.networking.hostName or "unknown";
  hostType =
    if hostname == "macbook-pro-2015" then "laptop"
    else if hostname == "desktop" then "desktop"
    else "unknown";

  isHiDPI = hostType == "laptop";
in {
  options.swaySystem.enable = lib.mkEnableOption "Enable Sway system-level configuration";

  config = lib.mkIf config.swaySystem.enable {
    programs.sway.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
          user = "ccaverotx";
        };
      };
    };

    environment.sessionVariables =
      {
        # Cursor (si home.pointerCursor no funciona bien)
        XCURSOR_THEME = "Nordzy-cursors-white";
        XCURSOR_SIZE = "30";

        # Escalado para apps electron y GTK
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
