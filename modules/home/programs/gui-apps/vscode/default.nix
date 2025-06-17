{ config, pkgs, lib, ... }:

let
  hostType = config.hostType;

  vscodePackage = if hostType == "macbook-pro-2015" then
    (pkgs.writeShellScriptBin "code" ''
      export NIXOS_OZONE_WL=1
      export ELECTRON_OZONE_PLATFORM_HINT=auto
      exec ${pkgs.vscode}/bin/code --ozone-platform=wayland
    '')
  else
    pkgs.vscode;

in {
  home.packages = [ vscodePackage ];

  home.sessionVariables = lib.mkIf (hostType == "macbook-pro-2015") {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
