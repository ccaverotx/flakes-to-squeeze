{ config, lib, pkgs, ... }:

{
  options.hyprlandSystem.enable = lib.mkEnableOption "Enable Hyprland system-level configuration";

  config = lib.mkIf config.hyprlandSystem.enable {
    programs.hyprland.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.displayManager.defaultSession = "hyprland";

    services.getty.autologinUser = "ccaverotx";

    environment.sessionVariables = {
      XCURSOR_THEME = "Nordzy-cursors-white";
      XCURSOR_SIZE = "30";
    };

    environment.systemPackages = with pkgs; [
      pantheon.pantheon-agent-polkit
    ];
  };
}
