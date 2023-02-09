{
  inputs = {
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.follows = "devenv/pre-commit-hooks";
  };

  outputs = {
    self,
    pre-commit-hooks,
    devenv,
    ...
  }: {
    flakeModules.default = {inputs, ...}: {
      perSystem = {
        config,
        pkgs,
        lib,
        ...
      }: {
        options.devenv = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submoduleWith {
            # Users might want to import devenvModules
            # from their own inputs but overwriting
            # them from a module doesn't seem necessary
            # hence they should be specialArgs
            specialArgs = let
              args = {inherit pre-commit-hooks;} // inputs;
            in
              args // {inputs = args;};
            modules = [
              (devenv.modules + /top-level.nix)
              ({config, lib, ...}: {
                options.enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether to enable this  devShell.
                  '';
                };
                config = {
                  # Users might want to overwrite the pkgs arg
                  # But importing from nixpkgs doesn't seem useful,
                  # they could always import from inputs.nixpkgs as well.
                  # the lib argument doesn't come from the pkgs argument,
                  # so no problems with needing lib for the import path
                  _module.args.pkgs = lib.mkOptionDefault pkgs;
                  packages = [
                    (import (devenv + /src/devenv-devShell.nix) {inherit config pkgs;})
                  ];
                  devenv.warnOnNewVersion = false;
                  devenv.flakesIntegration = true;
                };
              })
            ];
          });
          default = {};
        };
        config.devShells = lib.mapAttrs (name: devenv: devenv.shell) (lib.filterAttrs (name: devenv: devenv.enable) config.devenv);
      };
    };
    templates.simple = {
      path = ./examples/simple;
      description = "simple devenv-parts flake";
    };
    templates.default = self.templates.simple;
  };
}
