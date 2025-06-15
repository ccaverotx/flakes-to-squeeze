{ lib, pkgs, hostname, ... }:

let
  hostModules = {
    desktop = ./hosts/desktop;
    # laptop = ./hosts/laptop.nix;
  };
in {
  imports = [
    (import (hostModules.${hostname} or (throw "No home config for hostname: ${hostname}")))
  ];
}
