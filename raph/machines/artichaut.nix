{ config, pkgs, ... }:

{
  imports = [
    ../config.nix
    ../services.nix
    ../boot-plymouth.nix
    # ../portable.nix
  ];
  boot.initrd.availableKernelModules = [ "i915" ];
  boot.kernelModules = [ "i915" ];
  # boot.earlyModuleLoads = [ "i915" ];
}
