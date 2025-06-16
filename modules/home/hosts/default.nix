{ lib, pkgs, hostname, ... }:

let
  hostModules = {
    desktop = ./desktop;
    macbook-pro-2015 = ./macbook-pro-2015;
    # laptop = ./hosts/laptop.nix;
  };
in {
  imports = [
    (import (hostModules.${hostname} or (throw "No home config for hostname: ${hostname}")))
  ];
}
