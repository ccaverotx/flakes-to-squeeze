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
              extraArgs = [ "-f" ]; # forzar formato
              subvolumes = {
                "nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "persist/home" = {
                  mountpoint = "/persist/home";
                };

                "persist/home/${username}" = {
                  mountpoint = "/persist/home/${username}";
                };

                "persist/var" = {
                  mountpoint = "/persist/var";
                };

                "persist/etc-nixos" = {
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
      mountOptions = [ "mode=755" ];
    };
  };
}
