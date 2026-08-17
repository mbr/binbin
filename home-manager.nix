{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.binbin;
  binbin = if pkgs ? binbin then pkgs.binbin else pkgs.callPackage ./package.nix { };
  enabledTools = lib.filterAttrs (name: _package: cfg.${name}.enable) binbin.tools;
in
{
  options.programs.binbin = {
    enable = lib.mkEnableOption "all binbin tools";
  }
  // lib.mapAttrs (name: _package: {
    enable = lib.mkEnableOption "the ${name} tool";
  }) binbin.tools;

  config.home.packages = if cfg.enable then [ binbin ] else lib.attrValues enabledTools;
}
