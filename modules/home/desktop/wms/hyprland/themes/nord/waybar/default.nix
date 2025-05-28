{ config, pkgs, lib, ... }:

{
  config = {
    waybarConfig = {
      layer = "top";
      position = "top";
      modules-left = [ "clock" "custom/scratchpad-indicator" "idle_inhibitor" "custom/media" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "custom/cpugovernor" "cpu" "temperature" "custom/gpu" "pulseaudio" "bluetooth" "network" "tray" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        "format-icons" = {
          "1" = "<span color=\"#D8DEE9\"></span>";
          "2" = "<span color=\"#88C0D0\"></span>";
          "3" = "<span color=\"#A3BE8C\"></span>";
          "4" = "<span color=\"#D8DEE9\"></span>";
          urgent = "";
          focused = "";
          default = "";
        };
        "sort-by-number" = true;
      };

      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };

      "sway/window" = {
        format = "{}";
        max-length = 50;
        tooltip = false;
      };

      bluetooth = {
        interval = 30;
        format = "{icon}";
        format-icons = {
          enabled = "";
          disabled = "";
        };
        on-click = "blueberry";
      };

      "sway/language" = {
        format = "<big></big> {}";
        max-length = 5;
        min-length = 5;
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = true;
      };

      tray = {
        spacing = 5;
      };

      clock = {
        format = "  {:%H:%M:%S   %e %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        today-format = "<b>{}</b>";
        on-click = "gnome-calendar";
      };

      cpu = {
        interval = 1;
        format = "  {max_frequency}GHz <span color=\"darkgray\">| {usage}%</span>";
        max-length = 13;
        min-length = 13;
        on-click = "kitty -e htop --sort-key PERCENT_CPU";
        tooltip = false;
      };

      temperature = {
        interval = 4;
        hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
        critical-threshold = 74;
        format-critical = "  {temperatureC}°C";
        format = "{icon}  {temperatureC}°C";
        format-icons = [ "" "" "" ];
        max-length = 7;
        min-length = 7;
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        family = "ipv4";
        tooltip-format-wifi = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}\n {bandwidthUpBits}  {bandwidthDownBits}";
      };

      pulseaudio = {
        scroll-step = 3;
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
        on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      };

      "custom/pacman" = {
        format = "<big>􏆲</big>  {}";
        interval = 3600;
        exec = "checkupdates | wc -l";
        exec-if = "exit 0";
        on-click = "kitty -e 'yay'; pkill -SIGRTMIN+8 waybar";
        signal = 8;
        max-length = 5;
        min-length = 3;
      };

      "custom/weather" = {
        exec = "curl 'https://wttr.in/?format=1'";
        interval = 3600;
      };

      "custom/gpu" = {
        exec = "$HOME/.config/waybar/custom_modules/custom-gpu.sh";
        return-type = "json";
        format = "  {}";
        interval = 2;
        tooltip = "{tooltip}";
        max-length = 19;
        min-length = 19;
        on-click = "powerupp";
      };

      "custom/cpugovernor" = {
        format = "{icon}";
        interval = 30;
        return-type = "json";
        exec = "$HOME/.config/waybar/custom_modules/cpugovernor.sh";
        min-length = 2;
        max-length = 2;
        format-icons = {
          perf = "";
          sched = "";
        };
      };

      "custom/media" = {
        format = "{icon} {}";
        return-type = "json";
        max-length = 40;
        format-icons = {
          spotify = "";
          default = "🎜";
        };
        escape = true;
        exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
      };

      "custom/scratchpad-indicator" = {
        interval = 3;
        return-type = "json";
        exec = "swaymsg -t get_tree | jq --unbuffered --compact-output '( select(.name == \"root\") | .nodes[] | select(.name == \"__i3\") | .nodes[] | select(.name == \"__i3_scratch\") | .focus) as $scratch_ids | [..  | (.nodes? + .floating_nodes?) // empty | .[] | select(.id |IN($scratch_ids[]))] as $scratch_nodes | { text: \"\\($scratch_nodes | length)\", tooltip: $scratch_nodes | map(\"\\(.app_id // .window_properties.class) (\\(.id)): \\(.name)\") | join(\"\\n\") }'";
        format = "{} 􏠜";
        on-click = "exec swaymsg 'scratchpad show'";
        on-click-right = "exec swaymsg 'move scratchpad'";
      };
    };

    waybarStyle = ''
      @keyframes blink-warning {
          70% { color: @light; }
          to { color: @light; background-color: @warning; }
      }

      @keyframes blink-critical {
          70% { color: @light; }
          to { color: @light; background-color: @critical; }
      }

      /* Nord color palette and styles */
      @define-color bg #2E3440;
      @define-color light #D8DEE9;
      @define-color warning #ebcb8b;
      @define-color critical #BF616A;
      @define-color mode #434C5E;
      @define-color workspacesfocused #4C566A;
      @define-color tray @workspacesfocused;
      @define-color sound #EBCB8B;
      @define-color network #5D7096;
      @define-color memory #546484;
      @define-color cpu #596A8D;
      @define-color temp #4D5C78;
      @define-color layout #5e81ac;
      @define-color battery #88c0d0;
      @define-color date #434C5E;
      @define-color time #434C5E;
      @define-color backlight #434C5E;
      @define-color nord_bg #434C5E;
      @define-color nord_bg_blue #546484;
      @define-color nord_light #D8DEE9;
      @define-color nord_light_font #D8DEE9;
      @define-color nord_dark_font #434C5E;

      * {
          border: none;
          border-radius: 3px;
          min-height: 0;
          margin: 0.2em 0.3em;
      }

      #waybar {
          background: @bg;
          color: @light;
          font-family: "Cantarell", "Font Awesome 5 Pro";
          font-size: 12px;
          font-weight: bold;
      }

      #battery, #clock, #cpu, #memory, #network, #pulseaudio, #tray, #backlight {
          padding-left: 0.6em;
          padding-right: 0.6em;
      }

      #battery.critical.discharging,
      #memory.critical,
      #cpu.critical,
      #temperature.critical {
          animation-name: blink-critical;
          animation-duration: 2s;
          color: @critical;
      }

      #battery.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
      }

      #battery.warning,
      #cpu.warning,
      #temperature.warning,
      #network.disconnected {
          background: @warning;
          color: @nord_dark_font;
      }

      #workspaces button {
          font-weight: bold;
          opacity: 0.3;
          background: none;
          font-size: 1em;
          padding: 0;
      }

      #workspaces button.focused {
          background: @workspacesfocused;
          color: #D8DEE9;
          opacity: 1;
          padding: 0 0.4em;
      }

      #window {
          margin: 0 40px;
          font-weight: normal;
      }

      #clock {
          background: @nord_bg_blue;
          color: #D8DEE9;
      }

      #pulseaudio {
          background: @nord_bg_blue;
          color: #D8DEE9;
      }

      #tray {
          background: @tray;
      }

      #cpu { background: @nord_bg; color: #D8DEE9; }
      #memory { background: @memory; }
      #temperature { background: @nord_bg; }
      #network { background: @nord_bg_blue; }
      #battery { background: @battery; }
    '';
  };
}
