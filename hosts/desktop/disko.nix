{ config, lib, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      # El valor de device se sobrescribe desde la CLI con --disk main /dev/nvme0n1
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00"; # EFI System Partition
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          nix = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          };
        };
      };
    };

    nodev = {
      root = {
        fsType = "tmpfs";
        mountpoint = "/";
        mountOptions = [ "mode=755" ];
      };

      etc-nixos = {
        fsType = "none";
        mountpoint = "/etc/nixos";
        mountOptions = [ "bind" ];
      };

      home = {
        fsType = "none";
        mountpoint = "/home";
        mountOptions = [ "bind" ];
      };
    };
  };
}
