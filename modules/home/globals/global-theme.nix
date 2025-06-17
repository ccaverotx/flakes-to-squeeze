{ config, lib, ... }:

{
  options.hyprlandTheme.active = lib.mkOption {
    type = lib.types.str;
    default = "nord";
    description = "Tema activo para Hyprland";
  };
}
