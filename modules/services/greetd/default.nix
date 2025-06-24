{ config, pkgs, lib, ... }:

let
  swayCmd = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
in {
  options.greetd.enableSwaySession = lib.mkEnableOption "Enable tuigreet login for Sway";

  config = lib.mkIf config.greetd.enableSwaySession {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = swayCmd;
          user = "ccaverotx";
        };
      };
    };

    environment.systemPackages = [ pkgs.greetd.tuigreet ];
  };
}
