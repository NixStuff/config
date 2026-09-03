{
  description = "System flake";

  inputs = {
    unstablePkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    latestPkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "latestPkgs";
    };
    nur-latest-pkgs = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "latestPkgs";
    };
    nur-unstable-pkgs = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "unstablePkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "unstablePkgs";
        home-manager.follows = "home-manager";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "latestPkgs";
      inputs.home-manager.follows = "home-manager";
    };
    dev-vscode-extensions = {
      url = "github:MatthieuGomes/nixpkgs-dev/vscode-extensions";
    };
  };

  outputs = {
    self,
    unstablePkgs,
    latestPkgs,
    ...
  } @ Inputs: let
    system = "x86_64-linux";
    latest-version = "25.11";
    nixos-version = latest-version;
    latest = import latestPkgs {
      inherit system;
      ### Not sure if needed
      overlays = [
        Inputs.nur-latest-pkgs.overlays.default
      ];
      config = {
        allowUnfree = true;
      };
    };
    unstable = import unstablePkgs {
      inherit system;
      ### Not sure if needed
      overlays = [
        Inputs.nur-unstable-pkgs.overlays.default
      ];
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
    nix = {
      latest = latest;
      unstable = unstable;
    };
    nur-latest = Inputs.nur-latest-pkgs.legacyPackages.${system};
    nur-unstable = Inputs.nur-unstable-pkgs.legacyPackages.${system};
    dev-vscode-extensions = Inputs.dev-vscode-extensions.legacyPackages.${system};

    nur = {
      latest = nur-latest;
      unstable = nur-unstable;
    };
    dev = {
      vscode-extensions = dev-vscode-extensions;
    };

    customPkgs = import ./customPkgs.nix {
      pkgs = Inputs.latestPkgs.legacyPackages.${system};
    };
    others = {
      zen-browser = Inputs.zen-browser;
      customPkgs = customPkgs;
      dev = dev;
    };
    pkgs-list = {
      inherit nix;
      inherit nur;
      inherit others;
    };
    managers = {
      home = Inputs.home-manager;
      plasma = Inputs.plasma-manager;
    };
    inherit (Inputs) home-manager plasma-manager;
    lib = latest.lib;
    tools = import ./tools.nix {
      inherit lib;
    };
    baseSettings = {
      progs = {
        shells.enable = true;
        misc.enable = true;
        office.enable = true;
        dev.enable = true;
        browsers.enable = true;
        desktop.enable = true;
        terminals.enable = true;
        editors.enable = true;
        gaming.enable = true;
        tuis.enable = true;
      };
      sys = {
        label = "V.2.3.0_FEAT_LATEX";
        tags = [];
        version = nixos-version;
        main-user = "matthieu";
        hostname = "NixOS";
        bootloader.enable = true;
        lang.enable = true;
        users.enable = true;
        hardware.enable = true;
        networking.enable = true;
        filesystems.enable = true;
        fonts.enable = true;
        fstab.enable = true;
        display.enable = true;
      };
    };
  in {
    nixosConfigurations.${baseSettings.sys.hostname} = latestPkgs.lib.nixosSystem {
      pkgs = pkgs-list.nix.latest;
      specialArgs = {
        inherit pkgs-list;
        inherit Inputs;
        inherit managers;
        inherit baseSettings;
        inherit tools;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = {
              inherit Inputs;
              inherit pkgs-list;
              inherit latest;
              inherit nixos-version;
              inherit baseSettings;
              inherit tools;
            };
            useUserPackages = true;
            useGlobalPkgs = true;
            sharedModules = [plasma-manager.homeModules.plasma-manager];
            users.${baseSettings.sys.main-user} = import ./home.nix;
            backupFileExtension = "backup.bak";
            overwriteBackup = true;
          };
        }
      ];
    };
  };
}
