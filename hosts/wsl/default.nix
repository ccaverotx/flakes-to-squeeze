{ config, lib, pkgs, ... }:

{
  wsl.enable = true;

  programs.bash.loginShellInit = "nixos-wsl-welcome";

  # Fix para flake-based builds
  nixpkgs.flake.source = lib.mkForce null;

  # systemd completo no está disponible en WSL
  systemd.enable = false;

  # Otras configuraciones útiles en WSL pueden ir aquí
}
