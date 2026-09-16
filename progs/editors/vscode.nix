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
    name = "vscode";
    main-repo = "nix";
    branch = "unstable";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    extras = {
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.vscode = {
      enable = true;
      package = packages.vscode;
      mutableExtensionsDir = false;
      profiles = let
        root = {
          keybindings = [
            {
              command = "workbench.action.quit";
              key = "ctrl+shift+q";
            }
            {
              command = "-workbench.action.quit";
              key = "ctrl+q";
            }
          ];
          userSettings = {
            "telemetry.feedback.enabled" = false;
            "telemetry.editStats.enabled" = false;
            "workbench.colorTheme" = "Dark Modern";
            "window.zoomLevel" = -1;
            "editor.minimap.enabled" = false;
            "editor.wordWrap" = "on";
            "scm.defaultViewMode" = "tree";

            "diffEditor.ignoreTrimWhitespace" = false;

            "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
            "terminal.integrated.fontSize" = 15;
            "terminal.integrated.gpuAcceleration" = "off";
            "terminal.integrated.fontLigatures.enabled" = true;

            "github.copilot.nextEditSuggestions.enabled" = true;
            "github.copilot.enable" = {
              "*" = true;
              "plaintext" = true;
              "markdown" = true;
              "scminput" = false;
            };
            "chat.disableAIFeatures" = false;
            "ai-assisted-features.enabled" = true;
          };
          extensions = with packages.vscode-extensions;
            [
              github.vscode-github-actions

              ms-vscode-remote.remote-containers
              ms-vscode-remote.remote-ssh
              ms-vscode-remote.remote-ssh-edit
              ms-vscode.remote-explorer

              arrterian.nix-env-selector

              gruntfuggly.todo-tree
              jgclark.vscode-todo-highlight
            ]
            ++ (tools.ifEnabled config "config.progs.shells.direnv" [
              mkhl.direnv
            ])
            ++ packages.nix4vscode.forVscode [
              "joelkoz.nodeuml"
              "GitHub.vscode-pull-request-github"
            ];
        };
      in let
        basics = {
          Nix = {
            userSettings =
              {"github.copilot.enable" = {"nix" = true;};}
              // (
                (
                  tools.ifEnabled config "config.progs.dev.lang.nix.nil" {
                    "nix.enableLanguageServer" = true;
                    "nix.serverPath" = "nil";
                  }
                  // (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" {
                    "nix.serverSettings" = {
                      "nil" = {
                        "formatting" = {
                          "command" = [
                            "alejandra"
                          ];
                        };
                      };
                    };
                  })
                )
                // (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" {
                  "[nix]" = {
                    "editor.defaultFormatter" = "kamadorueda.alejandra";
                    "editor.formatOnPaste" = false;
                    "editor.formatOnSave" = false;
                    "editor.formatOnType" = false;
                  };
                  "nix.formatterPath" = "alejandra";
                  "alejandra.program" = "alejandra";
                })
              );
            extensions = with packages.vscode-extensions;
              (tools.ifEnabled config "config.progs.dev.lang.nix" [
                bbenoist.nix
                jnoortheen.nix-ide
              ])
              ++ (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" [
                kamadorueda.alejandra
              ]);
          };
          Python = {
            userSettings =
              {"github.copilot.enable" = {"python" = true;};}
              // (
                tools.ifEnabled config "config.progs.dev.lang.python" {
                  "python.analysis.typeCheckingMode" = "standard";
                }
              );
            extensions = with packages.vscode-extensions; (tools.ifEnabled config "config.progs.dev.lang.python" [
              ms-python.debugpy
              ms-python.python
              ms-python.vscode-pylance
            ]);
          };
          Perl =
            {"github.copilot.enable" = {"perl" = true;};}
            // {
              userSettings = {
                "[perl]" = {
                  "editor.tabSize" = 2;
                  "editor.insertSpaces" = true;
                };
              };
            };
          Vue = {
            userSettings = {
              "[vue]" = {
                "editor.defaultFormatter" = "Vue.volar";
              };
            };
          };
          LaTeX = {
            userSettings =
              {"github.copilot.enable" = {"latex" = true;};}
              // (tools.ifEnabled config "config.progs.dev.lang.latex" {
                "latex-workshop.latex.recipe.default" = "first";
                "latex-workshop.latex.clean.command" = "latexmk";
                "latex-workshop.latex.tools" = [
                  {
                    "name" = "latexmk";
                    "command" = "latexmk";
                    "args" = [
                      "-synctex=1"
                      "-interaction=nonstopmode"
                      "-file-line-error"
                      "-pdf"
                      "-outdir=%OUTDIR%"
                      "%DOC%"
                    ];
                    "latex-workshop.latex.tools" = [
                      {
                        "name" = "latexmk";
                        "command" = "latexmk";
                        "args" = [
                          "-synctex=1"
                          "-interaction=nonstopmode"
                          "-file-line-error"
                          "-pdf"
                          "-outdir=%OUTDIR%"
                          "%DOC%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "lualatexmk";
                        "command" = "latexmk";
                        "args" = [
                          "-synctex=1"
                          "-interaction=nonstopmode"
                          "-file-line-error"
                          "-lualatex"
                          "-outdir=%OUTDIR%"
                          "%DOC%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "xelatexmk";
                        "command" = "latexmk";
                        "args" = [
                          "-synctex=1"
                          "-interaction=nonstopmode"
                          "-file-line-error"
                          "-xelatex"
                          "-shell-escape"
                          "-outdir=%OUTDIR%"
                          "%DOC%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "latexmk_rconly";
                        "command" = "latexmk";
                        "args" = [
                          "%DOC%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "pdflatex";
                        "command" = "pdflatex";
                        "args" = [
                          "-synctex=1"
                          "-interaction=nonstopmode"
                          "-file-line-error"
                          "%DOC%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "bibtex";
                        "command" = "bibtex";
                        "args" = [
                          "%DOCFILE%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "rnw2tex";
                        "command" = "Rscript";
                        "args" = [
                          "-e"
                          "knitr==opts_knit$set(concordance = TRUE); knitr==knit('%DOCFILE_EXT%')"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "jnw2tex";
                        "command" = "julia";
                        "args" = [
                          "-e"
                          "using Weave; weave(\"%DOC_EXT%\" doctype=\"tex\")"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "jnw2texminted";
                        "command" = "julia";
                        "args" = [
                          "-e"
                          "using Weave; weave(\"%DOC_EXT%\" doctype=\"texminted\")"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "pnw2tex";
                        "command" = "pweave";
                        "args" = [
                          "-f"
                          "tex"
                          "%DOC_EXT%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "pnw2texminted";
                        "command" = "pweave";
                        "args" = [
                          "-f"
                          "texminted"
                          "%DOC_EXT%"
                        ];
                        "env" = {};
                      }
                      {
                        "name" = "tectonic";
                        "command" = "tectonic";
                        "args" = [
                          "--synctex"
                          "--keep-logs"
                          "--print"
                          "%DOC%.tex"
                        ];
                        "env" = {};
                      }
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "lualatexmk";
                    "command" = "latexmk";
                    "args" = [
                      "-synctex=1"
                      "-interaction=nonstopmode"
                      "-file-line-error"
                      "-lualatex"
                      "-outdir=%OUTDIR%"
                      "%DOC%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "xelatexmk";
                    "command" = "latexmk";
                    "args" = [
                      "-synctex=1"
                      "-interaction=nonstopmode"
                      "-file-line-error"
                      "-xelatex"
                      "-outdir=%OUTDIR%"
                      "%DOC%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "latexmk_rconly";
                    "command" = "latexmk";
                    "args" = [
                      "%DOC%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "pdflatex";
                    "command" = "pdflatex";
                    "args" = [
                      "-synctex=1"
                      "-interaction=nonstopmode"
                      "-file-line-error"
                      "%DOC%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "bibtex";
                    "command" = "bibtex";
                    "args" = [
                      "%DOCFILE%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "rnw2tex";
                    "command" = "Rscript";
                    "args" = [
                      "-e"
                      "knitr==opts_knit$set(concordance = TRUE); knitr==knit('%DOCFILE_EXT%')"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "jnw2tex";
                    "command" = "julia";
                    "args" = [
                      "-e"
                      "using Weave; weave(\"%DOC_EXT%\" doctype=\"tex\")"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "jnw2texminted";
                    "command" = "julia";
                    "args" = [
                      "-e"
                      "using Weave; weave(\"%DOC_EXT%\" doctype=\"texminted\")"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "pnw2tex";
                    "command" = "pweave";
                    "args" = [
                      "-f"
                      "tex"
                      "%DOC_EXT%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "pnw2texminted";
                    "command" = "pweave";
                    "args" = [
                      "-f"
                      "texminted"
                      "%DOC_EXT%"
                    ];
                    "env" = {};
                  }
                  {
                    "name" = "tectonic";
                    "command" = "tectonic";
                    "args" = [
                      "--synctex"
                      "--keep-logs"
                      "--print"
                      "%DOC%.tex"
                    ];
                    "env" = {};
                  }
                ];
                "latex-workshop.latex.recipes" = [
                  {
                    "name" = "latexmk (xelatex)";
                    "tools" = [
                      "xelatexmk"
                    ];
                  }
                  {
                    "name" = "latexmk (lualatex)";
                    "tools" = [
                      "lualatexmk"
                    ];
                  }
                  {
                    "name" = "latexmk";
                    "tools" = [
                      "latexmk"
                    ];
                  }
                  {
                    "name" = "latexmk (latexmkrc)";
                    "tools" = [
                      "latexmk_rconly"
                    ];
                  }
                  {
                    "name" = "pdflatex -> bibtex -> pdflatex * 2";
                    "tools" = [
                      "pdflatex"
                      "bibtex"
                      "pdflatex"
                      "pdflatex"
                    ];
                  }
                  {
                    "name" = "Compile Rnw files";
                    "tools" = [
                      "rnw2tex"
                    ];
                  }
                  {
                    "name" = "Compile Jnw files";
                    "tools" = [
                      "jnw2tex"
                    ];
                  }
                  {
                    "name" = "Compile Pnw files";
                    "tools" = [
                      "pnw2tex"
                    ];
                  }
                  {
                    "name" = "tectonic";
                    "tools" = [
                      "tectonic"
                    ];
                  }
                ];
                "latex-workshop.formatting.latex" = "tex-fmt";
                "[latex]" = {
                  "editor.quickSuggestions" = {
                    "strings" = true;
                  };
                };
              });
            extensions = with packages.vscode-extensions; (tools.ifEnabled config "config.progs.dev.lang.latex" [
              james-yu.latex-workshop
            ]);
          };
        };
      in let
        composite = {};
      in let
        profiles =
          {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = true;
              inherit (root) keybindings;
              userSettings =
                root.userSettings
                // {
                  "telemetry.telemetryLevel" = "off";
                  "http.proxySupport" = "off";
                  "security.workspace.trust.untrustedFiles" = "open";
                  "window.dialogStyle" = "custom";
                  "chat.tips.enabled" = false;
                  "window.newWindowProfile" = "Default";
                };
              extensions = with packages.vscode-extensions;
                root.extensions
                ++ [
                  tamasfe.even-better-toml
                ];
            };
          }
          // tools.vscode.namedFuse "Nix" basics.Nix root // tools.vscode.namedFuse "Python" basics.Python root // tools.vscode.namedFuse "Perl" basics.Perl root // tools.vscode.namedFuse "Vue" basics.Vue root // tools.vscode.namedFuse "LaTeX" basics.LaTeX root;
      in
        {
          inherit (profiles) default Nix Python Perl Vue LaTeX;
        }
        // tools.vscode.finishCombination (tools.vscode.combinePair {Nix = basics.Nix;} {Python = basics.Python;}) root;
    };
    home.activation = let
      profilesPath = "${config.home.homeDirectory}/.config/Code/User/profiles";
    in {
      stateDbCopy = let
        defaultStatePath = "${config.home.homeDirectory}/.config/Code/User/globalStorage/state.vscdb";
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          run /etc/nixos/progs/editors/stateDbCpy.sh ${profilesPath} ${defaultStatePath}
        '';
      # iconProfilesAttribution = let
      #   storageFilePath = "${config.home.homeDirectory}/.config/Code/User/profiles";
      # in
      #   lib.hm.dag.entryAfter ["writeBoundary"] ''
      #     run 
      #   '';
    };
  };
})
