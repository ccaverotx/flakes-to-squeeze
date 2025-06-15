{ config, lib, ... }:

{
  options.file-systems.zfs.enable = lib.mkEnableOption "Enable predefined ZFS filesystems for impermanence";

  config = lib.mkIf config.file-systems.zfs.enable {
    fileSystems."/etc/nixos" = {
      device = "zroot/nixos/persist/etc-nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    fileSystems."/persist" = {
      device = "zroot/nixos/persist";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    fileSystems."/persist/var" = {
      device = "zroot/nixos/persist/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    fileSystems."/persist/home" = {
      device = "zroot/nixos/persist/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    fileSystems."/persist/home/ccaverotx" = {
      device = "zroot/nixos/persist/home/ccaverotx";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };
  };
}
