# FIXME : Refactor this
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
    name = "plasma";
    subfolder = "plasma";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "klassy"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      klassy.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.plasma = {
      enable = true;
      configFile = {
        kdeglobals = {
          General = {
            TerminalApplication = "ghostty";
            TerminalService = "com.mitchellh.ghostty.desktop";
            ColorScheme = "KlassyDark";
          };
          KDE = {
            LookAndFeelPackage = "org.kde.breezedark.desktop";
            widgetStyle = "Klassy";
          };
        };
        plasmarc = {
          Theme = {
            name = "kite-light";
          };
        };
      };
      window-rules = [
        (tools.ifEnabled config "config.progs.editors.vscode" {
          description = "Fix duplicate VS Code entry in taskbar";
          match.window-class = "code code";
          apply.desktopfile = "code";
        })
        (tools.ifEnabled config "config.progs.misc.ledger"
          {
            description = "Fix icon in titlebar for Ledger Live";
            match.window-class = "ledger-live-desktop Ledger Wallet";
            apply.desktopfile = "ledger-live-desktop";
          })
        # TODO : REPORT BUG to OFFICE = doesnt work on creation, work when forced after beeing lunched
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice startcenter";
            match.window-class = "soffice.bin libreoffice-startcenter";
            apply.desktopfile = "startcenter";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice writer";
            match.window-class = "soffice.bin libreoffice-writer";
            apply.desktopfile = "writer";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice draw";
            match.window-class = "soffice.bin libreoffice-draw";
            apply.desktopfile = "draw";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice calc";
            match.window-class = "soffice.bin libreoffice-calc";
            apply.desktopfile = "calc";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice base";
            match.window-class = "soffice.bin libreoffice-base";
            apply.desktopfile = "base";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice math";
            match.window-class = "soffice.bin libreoffice-math";
            apply.desktopfile = "math";
          })
        (tools.ifEnabled config "config.progs.office.libreoffice"
          {
            description = "Fix icon in titlebar for libreoffice impress";
            match.window-class = "soffice.bin libreoffice-impress";
            apply.desktopfile = "impress";
          })
        # TODO : REPORT BUG to virt-manager = doesnt work on creation, work when forced after beeing lunched
        (tools.ifEnabled config "config.progs.dev.virtualization.virt-manager"
          {
            description = "Fix icon in titlebar for virt-manager";
            match.window-class = "python3.13 .virt-manager-wrapped";
            apply.desktopfile = "virt-manager";
          })
      ];
      shortcuts = {
        "services/com.mitchellh.ghostty.desktop" = {
          _launch = [
            "Meta+Return"
            "Ctrl+Alt+T"
          ];
          new-window = ["Meta+Shift+Return"];
        };
        ksmserver = {
          "Lock Session" = ["Meta+L"];
        };
        org_kde_powerdevil = {
          "Sleep" = ["Meta+Shift+L" "Sleep"];
        };
      };
      workspace = {
        colorScheme = "KlassyDark";
        windowDecorations = {
          library = "org.kde.klassy";
          theme = "Klassy";
        };
        iconTheme = "Klassy Dark";
        theme = "klassy";
      };
      panels = [
        {
          location = "top";
          height = 27;
          screen = "all";
          opacity = "adaptive";
          alignment = "center";
          widgets = [
            "org.kde.plasma.trash"
            {
              name = "org.kde.plasma.pager";
              config = {
                "currentDesktopSelected" = "ShowDesktop";
                "showOnlyCurrentScreen" = false;
                "showWindowOutlines" = false;
                "displayedText" = "Name";
                "wrapPage" = true;
                General = {
                  "displayedText" = "Name";
                  "wrapPage" = true;
                  "currentDesktopSelected" = "ShowDesktop";
                  "showOnlyCurrentScreen" = false;
                  "showWindowOutlines" = false;
                };
              };
            }
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.mediacontroller"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.notifications"
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.keyboardindicator"
            # PROJECT TODO : Fixing plasma manager so it supports configuring the system tray correctly and fully.
            {
              name = "org.kde.plasma.systemtray";
              config = {
                extraItems = ["org.kde.plasma.cameraindicator" "org.kde.kdeconnect" "org.kde.plasma.bluetooth" "org.kde.plasma.devicenotifier" "org.kde.plasma.printmanager" "org.kde.kscreen" "org.kde.plasma.keyboardlayout" "org.kde.plasma.manage-inputmethod"];
                hiddenItems = ["org.kde.kscreen" "org.kde.plasma.keyboardlayout" "org.kde.plasma.manage-inputmethod"];
                knownItems = ["org.kde.plasma.cameraindicator" "org.kde.plasma.clipboard" "org.kde.plasma.manage-inputmethod" "org.kde.kdeconnect" "org.kde.plasma.keyboardlayout" "org.kde.plasma.bluetooth" "org.kde.plasma.mediacontroller" "org.kde.plasma.notifications" "org.kde.plasma.devicenotifier" "org.kde.plasma.weather" "org.kde.kscreen" "org.kde.plasma.keyboardindicator" "org.kde.plasma.printmanager" "org.kde.plasma.brightness" "org.kde.plasma.volume" "org.kde.plasma.networkmanagement" "org.kde.plasma.battery"];
              };
            }
            # {
            #   systemTray = {
            #     pin = true;
            #     icons = {
            #       spacing = "medium";
            #       scaleToFit = true;
            #     };
            #     items = {
            #       showAll = false;
            #       shown = [
            #         "org.kde.plasma.battery"
            #         "org.kde.plasma.networkmanagement"
            #       ];
            #       hidden = [
            #         "org.kde.plasma.volume"
            #         "org.kde.kscreen"
            #       ];
            #     };
            #   };
            # }
            "org.kde.plasma.clipboard"
            "org.kde.plasma.brightness"
            "org.kde.plasma.volume"
            "org.kde.plasma.networkmanagement"
            {
              name = "org.kde.plasma.battery";
              config = {
                showPercentage = "true";
              };
            }
            {
              name = "org.kde.plasma.lock_logout";
              config = {
                show_lockScreen = false;
              };
            }
          ];
        }
        {
          location = "bottom";
          height = 44;
          screen = "all";
          opacity = "adaptive";
          alignment = "left";
          hiding = "dodgewindows";
          widgets = [
            "org.kde.plasma.kicker"
            # "org.kde.plasma.kickerdash"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                taskDisplayMode = "IconsOnly";
                showOnlyCurrentDesktop = true;
                groupTasks = true;
                launchers =
                  [
                    "applications:systemsettings.desktop"
                    "applications:org.kde.dolphin.desktop"
                  ]
                  ++ (tools.ifEnabled config "config.progs.browsers.firefox" ["applications:firefox.desktop"])
                  ++ (tools.ifEnabled config "config.progs.browsers.chromium" ["applications:chromium-browser.desktop"])
                  ++ (tools.ifEnabled config "config.progs.browsers.zen" ["applications:zen-beta.desktop"])
                  ++ (tools.ifEnabled config "config.progs.terminals.ghostty" ["applications:com.mitchellh.ghostty.desktop"])
                  ++ (tools.ifEnabled config "config.progs.editors.vscode" ["applications:code.desktop"]);
              };
            }
            "org.kde.plasma.showdesktop"
          ];
        }
      ];
      kwin = {
        titlebarButtons = {
          left = [];
        };
        virtualDesktops = {
          rows = 1;
          number = 3;
          names = ["Casual" "Work" "Dev"];
        };
        effects = {
          desktopSwitching = {
            animation = "slide";
            navigationWrapping = true; # NOTE : suggest to put this setting in "virtualDesktops" instead of "effects"
          };
          hideCursor = {
            enable = true;
            hideOnInactivity = 3; # seconds
            hideOnTyping = true;
          };
        };
      };
    };
    home.packages = with packages.kdePackages; [
      breeze
      filelight
    ];
  };
  System = {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    environment.plasma6.excludePackages = with packages.kdePackages; [
      elisa
      konsole
      discover
      okular
    ];
  };
})
