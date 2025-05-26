{ config, pkgs, lib, ... }:

let
  # Lista de monitores en orden lógico de izquierda a derecha
  monitors = [
    { name = "DP-2"; width = 1920; height = 1200; transform = 1; }  # Vertical a la izquierda
    { name = "DP-1"; width = 1920; height = 1080; transform = 0; }  # Horizontal al frente
  ];

  mapMonitors = lib.concatStringsSep "\n" (
    lib.imap0 (i: monitor:
      let
        posX = if i == 0 then 0 else (builtins.elemAt monitors (i - 1)).width;
        posY = if monitor.transform == 1 then "-350" else "0";
        res = "${toString monitor.width}x${toString monitor.height}";
        transformStr = if monitor.transform == 1 then ",transform,1" else "";
      in
        "monitor=${monitor.name},${res},${toString posX}x${posY},1${transformStr}"
    ) monitors
  );

  mapMonitorsToWs = lib.concatStringsSep "\n" (
    builtins.genList (
      x: let
        ws = x + 1;
        targetMonitor =
          if ws <= 5 then
            (builtins.elemAt monitors 1).name  # DP-1 (horizontal)
          else
            (builtins.elemAt monitors 0).name; # DP-2 (vertical)
        defaultFlag = if ws == 1 then ", default:true" else "";
      in "workspace = ${toString ws}, monitor:${targetMonitor}${defaultFlag}"
    ) 10
  );

in {
  wayland.windowManager.hyprland.extraConfig = ''
    # Monitor setup
    ${mapMonitors}

    # Workspace mapping
    ${mapMonitorsToWs}
  '';
}
