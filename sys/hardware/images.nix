{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "images";
    subfolder = "images";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "scanner"
      "printer"
    ];
    options = {
      enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
    };
    settings = {
      printer.enable = true;
      scanner.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
  };
  System = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
})
