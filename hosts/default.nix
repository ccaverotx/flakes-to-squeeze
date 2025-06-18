{ config, lib, pkgs, hostType, ... }:

let
  commonConfig = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.trusted-users = [ "root" "ccaverotx" ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/La_Paz";
    i18n.defaultLocale = "en_US.UTF-8";

    environment.systemPackages = with pkgs; [
      vim git wget pavucontrol sbctl niv
    ];
    
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        xorg.fontmiscmisc         # contiene 8x13
        xorg.fontcursormisc       # cursores X11
        xorg.fontadobe75dpi       # fuentes estilo Helvetica a 75 DPI
        xorg.fontadobe100dpi      # mismas a 100 DPI
      ];
    };



    system.stateVersion = "24.05";
  };

  nonWSLConfig = {
    users.users.ccaverotx = {
      subUidRanges = [ { startUid = 100000; count = 65536; } ];
      subGidRanges = [ { startGid = 100000; count = 65536; } ];
      isNormalUser = true;
      home = "/home/ccaverotx";
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "nixos";
    };

    networking.networkmanager.enable = true;

    boot.initrd.systemd.enable = true;
    boot.supportedFilesystems = [ "zfs" "ext4" ];

    systemd.tmpfiles.rules = [
      "d /etc/nixos 0755 ccaverotx users -"
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = false;
    };

    security.rtkit.enable = true;

    xdg.portal = {
      enable = true;
      config.common.default = "hyprland";
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      pipewire
      wireplumber
      xdg-utils
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
in
lib.mkMerge [
  commonConfig
  (lib.mkIf (hostType != "wsl") nonWSLConfig)
]
