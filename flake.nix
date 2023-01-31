{
  inputs = {
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.follows = "devenv/pre-commit-hooks";
    nixpkgs.follows = "devenv/nixpkgs";
  };

  outputs = {self, ...}: {
    flakeModules.default = import ./module.nix self;
  };
}
