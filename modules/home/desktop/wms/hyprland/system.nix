{ config, lib, pkgs, ... }:

{
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

    environment.sessionVariables = {
      GDK_SCALE = "2";
      XCURSOR_THEME = "Nordzy-cursors-white";
      XCURSOR_SIZE = "30";
      ELECTRON_ENABLE_HIGH_DPI_SCALING = "1";
      ELECTRON_FORCE_DEVICE_SCALE_FACTOR = "2";
    };

    environment.systemPackages = with pkgs; [
      greetd.tuigreet
      pantheon.pantheon-agent-polkit
    ];
  };
}
