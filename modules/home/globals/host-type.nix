{ config, lib, ... }:

{
  options.hostType = lib.mkOption {
    type = lib.types.str;
    default = "unknown";
    description = "Tipo de host actual (desktop, laptop, etc.)";
  };
}
