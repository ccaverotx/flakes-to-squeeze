{ config, impermanence, ... }:

{
  imports = [ impermanence.nixosModules.impermanence ];

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/polkit-1"
      #"/etc/nixos"
      "/etc/ssh"
      #"/home"
      "/var/lib/sbctl/"
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
