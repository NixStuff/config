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
    name = "zsh";
    subfolder = "zsh";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "oh-my-zsh"
      "fzf"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "An attribute set of shell aliases to define.";
        default = {};
      };
      p10k.enable = lib.mkEnableOption "Enables powerlevel10k zsh theme.";
package = lib.mkOption {
        type = lib.types.package;
        description = "The zsh package to use.";
        default = pkgs-list.nix.latest.zsh;
      };
    };
    settings = {
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          (tools.ifEnabled config "config.progs.shells.direnv" "direnv")
        ];
      };
      fzf.enable = true;
    };
  };
in
  (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.file.".p10k.zsh".text = "${builtins.readFile "${./${subfolder}/.p10k.zsh}"}";
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        ignoreAllDups = true;
      };
      defaultKeymap = "emacs";
      plugins = [
        (tools.ifEnabled config "config.progs.shells.zsh.p10k" {
          name = "powerlevel10k";
          src = packages.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        })
        (tools.ifEnabled config "config.progs.shells.zsh.fzf" {
          name = "fzf-tab";
          src = "${packages.zsh-fzf-tab}/share/fzf-tab";
        })
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = packages.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
      initContent =
        (tools.ifEnabled config "config.progs.shells.zsh.p10k"
          "source ~/.p10k.zsh\n")
        + "${builtins.readFile ./${subfolder}/init.zsh}"
        + (tools.ifEnabled config "config.progs.shells.zsh.fzf"
          "zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -a --color $realpath'");

      siteFunctions =
        {
          myip = "echo $(ip addr show wlp0s20f3 | grep -oP 'inet \\K[^/]+')";
        }
        // (
          tools.ifEnabled config "config.progs.tuis.yazi" {
            y = "${builtins.readFile ../tuis/yazi/y.zsh}";
          }
        );

      shellAliases = cfg.aliases;
    };
  };
  System = {
    programs.zsh.enable = true;
  };
})
// {
    package = pkgs-list.nix.unstable.zsh;
  }
