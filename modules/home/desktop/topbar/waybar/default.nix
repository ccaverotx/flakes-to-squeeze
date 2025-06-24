{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "battery" "tray" ];

        clock = {
          format = "{:%a %d %b  %H:%M}";
        };

        battery = {
          format = "{capacity}%";
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format-critical = "{capacity}% ⚠";
        };

        pulseaudio = {
          format = " {volume}%";
          format-muted = "";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
        color: #d8dee9;
        background: #2e3440;
      }
      window#waybar {
        border-bottom: 2px solid #81a1c1;
      }
    '';
  };
}