{ config, impermanence, ... }:

{
  imports = [ impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/polkit-1"
      "/etc/ssh"
      "/var/lib/sbctl"
      "/var/lib/bluetooth"
      "/var/lib/systemd"
      "/var/lib/nixos"
      "/home/ccaverotx/.mozilla"
      "/home/ccaverotx/.config"
      "/home/ccaverotx/.local"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
