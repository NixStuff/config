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
    name = "scanner";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
    };
  };
in
  (tools.fullModule rec {
    inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
    inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
    inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
    Home = {
    };
    System = {
      hardware.sane = {
        enable = true;
        extraBackends = with packages; [dsseries sane-airscan hplipWithPlugin];
      };
      users.groups.scanner.members = ["matthieu"];
      environment.systemPackages = with packages; [
        scanbd
        simple-scan
        kdePackages.skanlite
      ];
    };
  })
