{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
}
