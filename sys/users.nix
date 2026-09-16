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
    name = "users";
    togglable = false;
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
  defaultShellName = config.progs.shells.defaultShell;
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    users = {
      # mutableUsers = false; # BAZINGA
      defaultUserShell = config.progs.shells.${defaultShellName}.package;
      users = {
        ${config.sys.main-user} = {
          # password = ""; # BAZINGA
          # ignoreShellProgramCheck = true; # BAZINGA
          description = "Moi";
          isNormalUser = true;
          group = "users";
          extraGroups = [
            "wheel" # Enable sudo for the user.
          ];
          createHome = true;
          home = "/home/${config.sys.main-user}";
          /*
          openssh.authorizedKeys.keys = [
            ""
          ];
          */
        };
        # root.ignoreShellProgramCheck = true; # BAZINGA
      };
    };
  };
})
