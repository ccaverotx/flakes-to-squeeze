{ config, lib, pkgs, hostType, ... }:

let
  commonConfig = {
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "America/La_Paz";
    i18n.defaultLocale = "en_US.UTF-8";

    users.users.ccaverotx = {
      isNormalUser = true;
      home = "/home/ccaverotx";
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "nixos";
    };

    environment.systemPackages = with pkgs; [
      vim git wget pavucontrol sbctl niv
    ];

    system.stateVersion = "24.05";
  };

  nonWSLConfig = lib.mkMerge [
    {
      networking.networkmanager.enable = true;

      boot.initrd.systemd.enable = true;
      boot.supportedFilesystems = [ "ext4" ];

      systemd.tmpfiles.rules = [
        "d /etc/nixos 0755 ccaverotx users -"
      ];
    }

    # Puedes agregar más configuraciones específicas no-WSL aquí en el futuro
  ];
in
lib.mkMerge [
  commonConfig
  (lib.mkIf (hostType != "wsl") nonWSLConfig)
]
