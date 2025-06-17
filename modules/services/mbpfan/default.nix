{ config, lib, pkgs, ... }:

{
  config = {
    services.mbpfan = {
      enable = true;
      settings.general = {
        verbose = true;
        log_level = 2;
        daemon = true;
      };
    };

    environment.systemPackages = with pkgs; [ mbpfan ];
  };
}
