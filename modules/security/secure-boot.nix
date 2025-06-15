{ config, lib, ... }:

{
  options."secureBoot".enable = lib.mkEnableOption "Enable Secure Boot support";

  config = lib.mkIf config."secureBoot".enable {
    secureboot.enable = true;
  };
}
