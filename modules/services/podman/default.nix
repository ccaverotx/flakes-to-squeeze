{ config, lib, pkgs, ... }:

{
  options = {};

  config = {
    virtualisation.podman.enable = true;

    # Habilita compatibilidad con el CLI de Docker (`docker run`, etc.)
    virtualisation.podman.dockerCompat = true;

    # Habilita DNS interno para contenedores
    virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

    # Opción: arranca el socket para uso rootless
    systemd.user.services.podman = {
      wantedBy = [ "default.target" ];
    };
  };
}
