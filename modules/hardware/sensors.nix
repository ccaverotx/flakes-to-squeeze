{ config, pkgs, ... }:

{
  config = {
    hardware.sensor.iio.enable = true;

    # Descomenta si deseas habilitar también lm-sensors
    # hardware.lm-sensors.enable = true;

    environment.systemPackages = with pkgs; [
      lm_sensors
    ];
  };
}
