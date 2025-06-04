{ config, lib, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot"; 
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          nix = {
            name = "nix";
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
