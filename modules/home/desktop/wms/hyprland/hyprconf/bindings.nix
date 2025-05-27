{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "alt";
    "$rmod" = "ctrl";
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
      "$rmod, 1, workspace, 6"
      "$rmod, 2, workspace, 7"
      "$rmod, 3, workspace, 8"
      "$rmod, 4, workspace, 9"
      "$rmod, 5, workspace, 10"

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
