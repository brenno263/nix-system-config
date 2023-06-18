{
  description = "my minimal flake";
  inputs = {
    # Where we get most of our software, giant monorepo
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Managers configs and links things into home dir
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings, like fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Tricked out nvim
    pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs: {
    # Nix-Darwin looks for this key
    darwinConfigurations.Brennans-MacBook-Pro = inputs.darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = import inputs.nixpkgs {system = "x86_64-darwin";};
      modules = [
        ({pkgs, ...}: {
          # Here go darwin preferences and config items
          users.users.bseymour.home = "/Users/bseymour";
          programs.zsh.enable = true;
          environment.shells = [pkgs.bash pkgs.zsh];
          environment.loginShell = pkgs.zsh;
          environment.systemPackages = [pkgs.coreutils];
          environment.systemPath = ["/opt/homebrew/bin"];
          environment.pathsToLink = ["/Applications"];
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToEscape = true;
          fonts.fontDir.enable = true; # Danger? This will use ONLY these fonts
          fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
          services.nix-daemon.enable = true;
          system.defaults.finder.AppleShowAllExtensions = true;
          system.defaults.finder._FXShowPosixPathInTitle = true;
          system.defaults.dock.autohide = true;
          system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
          system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
          system.defaults.NSGlobalDomain.KeyRepeat = 1;
          homebrew = {
            enable = true;
            caskArgs.no_quarantine = true;
            global.brewfile = true;
            masApps = {};
            casks = ["raycast" "amethyst"];
            brews = ["trippy"];
          };
        })
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.bseymour.imports = [
              ({pkgs, ...}: {
                #backwards-compat measure, do not change
                home.stateVersion = "22.11";

                #specify my home-manager configs
                home.packages = [
                  pkgs.ripgrep
                  pkgs.fd
                  pkgs.curl
                  pkgs.less
                  inputs.pwnvim.packages."x86_64-darwin".default
                ];
                home.sessionVariables = {
                  PAGER = "less";
                  CLICOLOR = 1;
                  EDITOR = "nvim";
                };
                programs.bat.enable = true;
                programs.bat.config.theme = "TwoDark";
                programs.fzf.enable = true;
                programs.fzf.enableZshIntegration = true;
                programs.exa.enable = true;
                programs.zsh.enable = true;
                programs.zsh.enableCompletion = true;
                programs.zsh.enableAutosuggestions = true;
                programs.zsh.enableSyntaxHighlighting = true;
                programs.zsh.shellAliases = {ls = "ls --color=auto -F";};
                programs.starship.enable = true;
                programs.starship.enableZshIntegration = true;
                programs.alacritty = {
                  enable = true;
                  settings.font.normal.family = "MesloLGS Nerd Font Mono";
                  settings.font.size = 16;
                };
                home.file.".inputrc".text = ''
                  set show-all-if-ambiguous on
                  set completion-ignore-case on
                  set mark-directories on
                  set mark-symlinked-directories on
                  set match-hidden-files off
                  set visible-stats on
                  set keymap vi
                  set editing-mode vi-insert
                '';
              })
            ];
          };
        }
      ];
    };
  };
}
