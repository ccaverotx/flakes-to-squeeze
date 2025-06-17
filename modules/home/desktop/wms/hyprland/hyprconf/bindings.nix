{ config, pkgs, lib, ... }:

let
  hostType = config.hostType;

  commonBinds = ''
    $mod = ALT
    $lmod = CTRL

    # Lanzadores
    bind = $mod, RETURN, exec, kitty
    bind = $mod SHIFT, RETURN, exec, kitty --class="termfloat"
    bind = $mod, F1, exec, firefox
    bind = $mod, C, exec, code
    bind = $mod, D, exec, rofi -show drun

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $lmod, 1, workspace, 6
    bind = $lmod, 2, workspace, 7
    bind = $lmod, 3, workspace, 8
    bind = $lmod, 4, workspace, 9
    bind = $lmod, 5, workspace, 10

    # Operadores de ventana
    bind = $mod SHIFT, Q, killactive
    bindo = $mod, escape, killactive
    bind = $mod, T, togglefloating
    bind = $mod , F11, fullscreen

    # Resize submap
    bind = $mod, S, submap, resize
    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset

    # Navegación entre ventanas con $mod + flechas
    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    # Submap de mover ventanas entre workspaces
    bind = $mod, M, submap, movewindow
    submap = movewindow
    bind = ,1, movetoworkspace, 1
    bind = ,2, movetoworkspace, 2
    bind = ,3, movetoworkspace, 3
    bind = ,4, movetoworkspace, 4
    bind = ,5, movetoworkspace, 5
    bind = ctrl,1, movetoworkspace, 6
    bind = ctrl,2, movetoworkspace, 7
    bind = ctrl,3, movetoworkspace, 8
    bind = ctrl,4, movetoworkspace, 9
    bind = ctrl,5, movetoworkspace, 10
    bind = , escape, submap, reset
    submap = reset

    # Submap de mover ventanas flotantes
    bind = $mod, G, submap, movefloating
    submap = movefloating
    binde = ,right, moveactive, 20 0
    binde = ,left, moveactive, -20 0
    binde = ,up, moveactive, 0 -20
    binde = ,down, moveactive, 0 20
    bind = ,escape, submap, reset
    submap = reset

    # Submap de mover ventanas en el mismo workspace
    bind = $mod, N, submap, movetiled
    submap = movetiled
    bind = ,right, swapwindow, r
    bind = ,left, swapwindow, l
    bind = ,up, swapwindow, u
    bind = ,down, swapwindow, d
    bind = ,escape, submap, reset
    submap = reset
  '';

  macbookSpecificBinds = ''
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
  '';


  trackballConfig = ''
    device {
      name = logitech-usb-trackball
      scroll_method = on_button_down
      natural_scroll = true
    }
  '';
in

{
  wayland.windowManager.hyprland.extraConfig =
    commonBinds
    + (lib.optionalString (hostType == "macbook-pro-2015") macbookSpecificBinds)
    + trackballConfig;
}
