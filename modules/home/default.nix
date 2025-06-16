{ lib, pkgs, hostname, ... }:

let
  hostModules = {
    desktop = ./hosts/desktop;
    macbook-pro-2015 = ./hosts/macbook-pro-2015;
    # laptop = ./hosts/laptop.nix;
  };
in {
  imports = [
    (import (hostModules.${hostname} or (throw "No home config for hostname: ${hostname}")))
  ];
}
