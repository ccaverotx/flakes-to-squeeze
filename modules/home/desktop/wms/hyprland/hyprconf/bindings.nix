{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "alt";
    bind = [
      "$mod, RETURN, exec, kitty"
      "$mod, F, exec, firefox"
      "$mod, C, exec, code"
      "$mod, n, exec, nemo"
      "$mod SHIFT, Return, exec, kitty --class=\"termfloat\""
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"

    ];
  };

  wayland.windowManager.hyprland.extraConfig =
    ''
      bind = $mod, S, submap, resize # enter resize window to resize the active window
      submap=resize
      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10
      bind=,escape,submap,reset
      submap=reset
    '';
}
