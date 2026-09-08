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
    name = "printer";
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
      services.printing = {
        enable = true;
        startWhenNeeded = true;
        drivers = with packages; [
          cnijfilter2
          gutenprint
          hplip
          hplipWithPlugin
        ];
      };
      users.groups.lp.members = ["matthieu"];
    };
  })
