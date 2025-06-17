{ config, pkgs, ... }:

{
  config = {
    hardware.bluetooth.enable = true;

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
      blueman
    ];
  };
}
