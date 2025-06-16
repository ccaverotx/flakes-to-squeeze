{ lib, ... }:

let
  username = "ccaverotx";
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" "x-initrd.mount" ];
                };

                "/persist/home" = { };

                "/persist/home/${username}" = { };

                "/persist/var" = {
                  mountpoint = "/persist/var";
                };

                "/persist/etc-nixos" = {
                  mountpoint = "/persist/etc-nixos";
                };
              };
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "mode=755"
        "size=4G" # limita a 4 GB de RAM
      ];
    };
  };
}
