{ config, pkgs, lib, ... }:

let
  # Lista de monitores en orden lógico de izquierda a derecha
  monitors = [
    { name = "DP-2"; width = 1920; height = 1200; transform = 9; }  # Vertical a la izquierda
    { name = "DP-1"; width = 1920; height = 1080; transform = 0; }  # Horizontal al frente
  ];

  # Solo mantener el cálculo de workspace → monitor
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
    ### --- Monitor Layout ---
    monitor=DP-2,1920x1200,0x0,1,transform,1
    monitor=DP-1,1920x1080@180,1920x0,1
    # Workspace mapping
    ${mapMonitorsToWs}
  '';
}
