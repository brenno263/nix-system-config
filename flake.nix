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
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    darwin,
    pwnvim,
    ...
  }: {
    # Nix-Darwin looks for this key
    darwinConfigurations.Brennans-MacBook-Pro = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = import nixpkgs {system = "x86_64-darwin";};
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
