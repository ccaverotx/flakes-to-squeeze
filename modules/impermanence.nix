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
      "/home/${config.myUsername}/.mozilla"
      "/home/${config.myUsername}/.config"
      "/home/${config.myUsername}/.local"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
