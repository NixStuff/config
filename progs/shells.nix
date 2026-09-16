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
    name = "shells";
    togglable = false;
    subfolder = "shells";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "zsh"
      "direnv"
    ];
    extras = {
      aliases =
        {
          nrs = "sudo nixos-rebuild switch";
          nrt = "sudo nixos-rebuild test";
          ls = "ls --color=auto -ah";
          ".." = "cd ..";
          myip = "myip";
        }
        // (tools.ifEnabled config "config.progs.shells.zsh.yazi" {
          yazi = "y";
        });

      p10k = {
        enable = true;
      };
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      zsh = {
        enable = true;
        inherit (extras) aliases p10k;
      };
      direnv.enable = true;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
