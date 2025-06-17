{ config, pkgs, lib, ... }:

let
  hostType = config.hostType;

  monitors =
    if hostType == "desktop" then [
      { name = "DP-2"; width = 1920; height = 1200; x = 0; y = 0; scale = 1; transform = 3; }
      { name = "DP-1"; width = 1920; height = 1080; x = 1920; y = 0; scale = 1; refresh = "180"; }
    ] else if hostType == "macbook-pro-2015" then [
      { name = "eDP-1"; width = 2880; height = 1800; x = 0; y = 0; scale = 2; }
    ] else [];

  # Convierte cada entrada en una línea de Hyprland
  renderMonitor = m:
  let
    resolution = "${toString m.width}x${toString m.height}" +
                 (if m ? refresh then "@${m.refresh}" else "");

    base = "${m.name},${resolution},${toString m.x}x${toString m.y},${toString m.scale}";

    transform = if m ? transform then ",transform,${toString m.transform}" else "";
  in
    "monitor=${base}${transform}";


  monitorBlock = lib.concatStringsSep "\n" (map renderMonitor monitors);

  # Workspace mapping igual que antes
  mapMonitorsToWs = lib.concatStringsSep "\n" (
    builtins.genList (
      x: let
        ws = x + 1;
        targetMonitor =
          if hostType == "desktop" then
            if ws <= 5 then
              (builtins.elemAt monitors 1).name
            else
              (builtins.elemAt monitors 0).name
          else
            (builtins.elemAt monitors 0).name;
        defaultFlag = if ws == 1 then ", default:true" else "";
      in "workspace = ${toString ws}, monitor:${targetMonitor}${defaultFlag}"
    ) 10
  );

in {
  wayland.windowManager.hyprland.extraConfig = ''
  ### --- Monitor Layout for ${hostType} ---
  ${monitorBlock}

  # Workspace mapping
  ${mapMonitorsToWs}

  # XWayland HiDPI fix
  xwayland {
    force_zero_scaling = true
  }
'';
}
