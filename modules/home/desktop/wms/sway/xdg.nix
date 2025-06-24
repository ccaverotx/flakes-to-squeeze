{ config, pkgs, lib, ... }:

{
  xdg.enable = true;

  # Asegura que la sesión de Sway tenga estas variables disponibles
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1"; # A veces ayuda con tarjetas gráficas Intel/NVIDIA
  };
}
