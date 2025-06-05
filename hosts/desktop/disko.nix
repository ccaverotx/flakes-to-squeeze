{ config, lib, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      # El valor de `device` se pasa vía CLI: --disk main /dev/nvme0n1
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
        depends = [ "/nix" ];
        source = "/nix/persist/etc/nixos";
      };

      home = {
        fsType = "none";
        mountpoint = "/home";
        mountOptions = [ "bind" ];
        depends = [ "/nix" ];
        source = "/nix/persist/home";
      };

      var-lib-nixos = {
        fsType = "none";
        mountpoint = "/var/lib/nixos";
        mountOptions = [ "bind" ];
        depends = [ "/nix" ];
        source = "/nix/persist/var/lib/nixos";
      };
    };
  };
}
