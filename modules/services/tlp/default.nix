{ config, pkgs, ... }:

{
  config = {
    services.tlp.enable = true;

    environment.systemPackages = with pkgs; [
      tlp
      acpi
    ];
  };
}
