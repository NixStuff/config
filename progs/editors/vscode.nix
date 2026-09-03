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
      profiles.default = {
        enableExtensionUpdateCheck = true;
        enableUpdateCheck = true;
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
        userSettings =
          {
            "telemetry.feedback.enabled" = false;
            "telemetry.editStats.enabled" = false;
            "telemetry.telemetryLevel" = "off";

            "http.proxySupport" = "off";
            "security.workspace.trust.untrustedFiles" = "open";

            "window.newWindowProfile" = "Default";
            "workbench.colorTheme" = "Dark Modern";
            "window.dialogStyle" = "custom";
            "window.zoomLevel" = -1;
            "editor.minimap.enabled" = false;
            "editor.wordWrap" = "on";
            "scm.defaultViewMode" = "tree";

            "diffEditor.ignoreTrimWhitespace" = true;

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
            "chat.tips.enabled" = false;

            "[perl]" = {
              "editor.tabSize" = 2;
              "editor.insertSpaces" = true;
            };
            "[vue]" = {
              "editor.defaultFormatter" = "Vue.volar";
            };
          }
          // (
            tools.ifEnabled config "config.progs.dev.lang.nix" {
            }
            // (
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
          )
          // (tools.ifEnabled config "config.progs.dev.lang.python" {
            "python.analysis.typeCheckingMode" = "standard";
          })
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

        extensions = with packages.vscode-extensions;
          [
            github.vscode-github-actions
            github.vscode-pull-request-github

            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode.remote-explorer
          ]
          ++ [
            pkgs-list.others.dev.vscode-extensions.vscode-extensions.joelkoz.nodeuml
            # pkgs-list.others.dev.vscode-extensions.vscode-extensions.danielatanasov.todo
            # pkgs-list.others.dev.vscode-extensions.vscode-extensions.prateekmahendrakar.prettyxml
            # pkgs-list.others.dev.vscode-extensions.vscode-extensions.zhiyuan-lin.simple-perl
          ]
          ++ (tools.ifEnabled config "config.progs.shells.direnv" [
            mkhl.direnv
          ])
          ++ [
            gruntfuggly.todo-tree
            jgclark.vscode-todo-highlight
          ]
          ++ (tools.ifEnabled config "config.progs.dev.lang.nix" [
            arrterian.nix-env-selector
            bbenoist.nix
            jnoortheen.nix-ide
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" [
            kamadorueda.alejandra
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.python" [
            ms-python.debugpy
            ms-python.python
            ms-python.vscode-pylance
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.latex" [
            james-yu.latex-workshop
          ])
          ++ [
            tamasfe.even-better-toml
          ];
        # ++ [
        #   DavidAnson.vscode-markdownlint
        # ];
      };
    };

    home.activation = {
      "${name}_settings" = let
        config_path = "${config.xdg.configHome}/Code/User";
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p ${config_path}
          rm -f ${config_path}/settings.json ${config_path}/keybindings.json
          cp $newGenPath/home-files/.config/Code/User/settings.json ${config_path}/settings.json
          cp $newGenPath/home-files/.config/Code/User/keybindings.json ${config_path}/keybindings.json
          chmod 644 ${config_path}/settings.json ${config_path}/keybindings.json
        '';
      # "${name}_extensions" = let
      #   extensions_path = "$HOME/.vscode/extensions";
      #   extensions_editable_path = "$HOME/.vscode/extensions-editable";
      # in
      #   lib.hm.dag.entryAfter ["writeBoundary"] ''
      #     mkdir -p ${extensions_editable_path}
      #     cp -r $newGenPath/home-files/.vscode/extensions/* ${extensions_editable_path}/
      #     rm -f ${extensions_editable_path}/extensions.json
      #     cp $newGenPath/home-files/.vscode/extensions/extensions.json ${extensions_editable_path}/extensions.json
      #     chmod 644 ${extensions_editable_path}/extensions.json
      #     chmod 755 ${extensions_editable_path}
      #     rm -rf ${extensions_path}
      #     mv ${extensions_editable_path} ${extensions_path}
      #   '';
    };
  };
})
