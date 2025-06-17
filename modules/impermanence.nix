{ config, impermanence, pkgs, ... }:

{
  imports = [ impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/polkit-1"
      "/etc/ssh"
      "/etc/NetworkManager"
      "/var/lib/NetworkManager"
      "/var/lib/sbctl"
      "/var/lib/bluetooth"
      "/var/lib/systemd"
      "/var/lib/nixos"
      "/home/ccaverotx/"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/nixos - - - - /persist/etc-nixos"
    "d /persist/etc-nixos 0755 ccaverotx users -"
  ];

  ## Esto instala chown para corregir permisos manuales si alguna vez hace falta
  environment.systemPackages = with pkgs; [ coreutils ];
}
