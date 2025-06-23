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
    /* Mechabar Classic adaptado a Nord */

    @define-color rosewater       #F5E0DC;
    @define-color flamingo        #F2CDCD;
    @define-color pink            #F5C2E7;
    @define-color mauve           #CBA6F7;
    @define-color red             #BF616A;
    @define-color maroon          #EBA0AC;
    @define-color peach           #D08770;
    @define-color yellow          #EBCB8B;
    @define-color green           #A3BE8C;
    @define-color teal            #88C0D0;
    @define-color sky             #81A1C1;
    @define-color sapphire        #5E81AC;
    @define-color blue            #5E81AC;
    @define-color lavender        #B48EAD;
    @define-color text            #D8DEE9;
    @define-color subtext1        #BAC2DE;
    @define-color subtext0        #A6ADC8;
    @define-color overlay2        #9399B2;
    @define-color overlay1        #7F849C;
    @define-color overlay0        #6C7086;
    @define-color surface2        #585B70;
    @define-color surface1        #434C5E;
    @define-color surface0        #3B4252;
    @define-color base            #2E3440;
    @define-color mantle          #2E3440;
    @define-color crust           #2E3440;

    @define-color white           #FFFFFF;
    @define-color black           #000000;

    @define-color shadow          shade(@crust, 0.5);
    @define-color main-fg         @text;
    @define-color main-bg         @crust;
    @define-color main-br         @text;

    @define-color active-bg       @overlay2;
    @define-color active-fg       @crust;

    @define-color hover-bg        @surface0;
    @define-color hover-fg        alpha(@text, 0.75);

    @define-color module-fg       @text;
    @define-color workspaces      @mantle;

    @define-color temperature     @mantle;
    @define-color memory          @base;
    @define-color cpu             @surface0;
    @define-color distro-fg       @black;
    @define-color distro-bg       @overlay2;
    @define-color time            @surface0;
    @define-color date            @base;
    @define-color tray            @mantle;

    @define-color pulseaudio      @mantle;
    @define-color backlight       @base;
    @define-color battery         @surface0;
    @define-color power           @overlay2;

    @define-color warning         @yellow;
    @define-color critical        @red;
    @define-color charging        @text;

    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font", "Font Awesome 5 Pro", "Font Awesome 6 Free";
      font-size: 14px;
      min-height: 0;
      margin: 0;
      padding: 0;
    }

    #waybar {
      background-color: @main-bg;
      color: @main-fg;
      border-bottom: 1px solid @main-br;
      transition: all 0.3s ease;
    }

    window#waybar {
      opacity: 0.95;
    }

    #workspaces button {
      padding: 0 6px;
      color: @module-fg;
      background: @workspaces;
      border-radius: 4px;
      margin-right: 2px;
    }

    #workspaces button.active {
      background: @active-bg;
      color: @active-fg;
    }

    #workspaces button:hover {
      background: @hover-bg;
      color: @hover-fg;
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #network,
    #temperature,
    #backlight,
    #pulseaudio,
    #tray,
    #custom-media,
    #custom-weather,
    #custom-pacman,
    #custom-cpugovernor,
    #custom-gpu,
    #custom-scratchpad-indicator,
    #idle_inhibitor {
      padding: 0 10px;
      margin: 0 4px;
      border-radius: 4px;
    }

    #battery.warning,
    #cpu.warning,
    #temperature.warning,
    #network.disconnected {
      background-color: @warning;
      color: @black;
    }

    #battery.critical,
    #cpu.critical,
    #temperature.critical {
      background-color: @critical;
      color: @white;
      animation-name: blink-critical;
      animation-duration: 2s;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    @keyframes blink-critical {
      0% { background-color: @critical; color: @white; }
      100% { background-color: @main-bg; color: @critical; }
    }
    '';
  };
}
