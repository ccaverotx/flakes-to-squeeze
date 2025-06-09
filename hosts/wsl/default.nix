{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "ccaverotx";

  programs.bash.loginShellInit = "nixos-wsl-welcome";

  # Fix para flake-based builds
  nixpkgs.flake.source = lib.mkForce null;

  # Obligatorio para prevenir advertencias y mantener compatibilidad
  system.stateVersion = "24.05";
}
