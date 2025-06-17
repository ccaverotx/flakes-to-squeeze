{ config, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      brightnessctl
      acpilight
    ];
  };
}
