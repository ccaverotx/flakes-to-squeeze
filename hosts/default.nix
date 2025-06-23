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
  };
in
lib.mkMerge [
  commonConfig
  (lib.mkIf (hostType != "wsl") nonWSLConfig)
]
