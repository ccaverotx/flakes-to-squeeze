{ lib, ... }:

let
  poolName = "zroot";
  pseudoRoot = "nixos";
  username = "ccaverotx";
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
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
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = poolName;
            };
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "mode=755" ];
    };

    zpool.${poolName} = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        atime = "off";
        mountpoint = "none";
        xattr = "sa";
        acltype = "posixacl";
        compression = "lz4";
      };
      datasets = {
        "${pseudoRoot}".type = "zfs_fs";

        "${pseudoRoot}/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.mountpoint = "legacy";
        };

        "${pseudoRoot}/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options.mountpoint = "legacy";
          # Eliminar canmount = off
          options.encryption = "aes-256-gcm";
          options.keyformat = "passphrase";
          options.keylocation = "prompt";
        };

        "${pseudoRoot}/persist/home" = {
          type = "zfs_fs";
          mountpoint = "/persist/home";
          options.mountpoint = "legacy";
        };

        "${pseudoRoot}/persist/var" = {
          type = "zfs_fs";
          mountpoint = "/persist/var";
          options.mountpoint = "legacy";
        };

        "${pseudoRoot}/persist/etc-nixos" = {
          type = "zfs_fs";
          mountpoint = "/persist/etc-nixos";
          options.mountpoint = "legacy";
        };

        "${pseudoRoot}/persist/home/${username}" = {
          type = "zfs_fs";
          mountpoint = "/persist/home/${username}";
          options.mountpoint = "legacy";
        };
      };
    };
  };
}
