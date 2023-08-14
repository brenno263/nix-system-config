{
  description = "System configuraton for my company macbook";
  inputs = {
    # Where we get most of our software, giant monorepo
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    # Managers configs and links things into home dir
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings, like fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nvim config. I'm not using it but I'll leave it in as a reminder of how to do such a thing
    pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    home-manager,
    darwin,
    pwnvim,
    ...
  }: let
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        inherit
          (import ./modules/overlays.nix {
            inherit inputs nixpkgs-unstable nixpkgs-stable;
          })
          overlays
          ;
        config = import ./config.nix;
      };
  in {
    # Nix-Darwin looks for this key
    darwinConfigurations.Brennans-MacBook-Pro = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = mkPkgs "x86_64-darwin";
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit pwnvim;};
            users.bseymour.imports = [./modules/home-manager];
          };
        }
      ];
    };
  };
}
