{ config, lib, ... }:

{
  options.file-systems.btrfs.enable = lib.mkEnableOption "Enable predefined Btrfs filesystems for impermanence";

  config = lib.mkIf config.file-systems.btrfs.enable {
    fileSystems."/etc/nixos" = {
      device = "/dev/disk/by-label/etc-nixos";
      fsType = "btrfs";
      neededForBoot = true;
    };

    fileSystems."/persist" = {
      device = "/dev/disk/by-label/persist";
      fsType = "btrfs";
      neededForBoot = true;
    };

    fileSystems."/persist/var" = {
      device = "/dev/disk/by-label/var";
      fsType = "btrfs";
      neededForBoot = true;
    };

    fileSystems."/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "btrfs";
      neededForBoot = true;
    };

    fileSystems."/persist/home/ccaverotx" = {
      device = "/dev/disk/by-label/ccaverotx";
      fsType = "btrfs";
      neededForBoot = true;
    };
  };
}
