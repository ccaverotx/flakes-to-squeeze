{ config, pkgs, impermanence, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../modules/impermanence.nix
    ../modules/hyprland.nix
    ../modules/security/polkit.nix
  ];

  networking.hostName = "nixhypr";

  # Habilita Hyprland en NixOS
  programs.hyprland.enable = true;

  # Configuración del display manager y sesión por defecto
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.displayManager.defaultSession = "hyprland";

  time.timeZone = "America/La_Paz";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.ccaverotx = {
    isNormalUser = true;
    home = "/home/ccaverotx";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos";
  };

  nixpkgs.config.allowUnfree = true;
  
  services.getty.autologinUser = "ccaverotx";

  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = [ "ext4" ];

  security.polkit.enable = true;
  
  environment.systemPackages = with pkgs; [
    vim git wget pantheon.pantheon-agent-polkit
  ];

  systemd.tmpfiles.rules = [
    "d /etc/nixos 0755 ccaverotx users -"
  ];

  system.stateVersion = "24.05";
}
