{
  inputs = {
    devenv.url = "github:cachix/devenv";
    pre-commit-hooks.follows = "devenv/pre-commit-hooks";
  };

  outputs = {
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
          type = lib.types.submoduleWith {
            modules = [
              (devenv.modules + /top-level.nix)
              ({
                config,
                pkgs,
                ...
              }: {
                packages = [
                  (import (devenv + /src/devenv-devShell.nix) {inherit config pkgs;})
                ];
                devenv.warnOnNewVersion = false;
                devenv.flakesIntegration = true;
              })
              {
                _module.args.pkgs = pkgs;
                _module.args.inputs =
                  {inherit pre-commit-hooks;} // inputs;
              }
              {
                _module.args = {inherit pre-commit-hooks;} // inputs;
              }
            ];
          };
          default = {};
        };
        config.devShells.default = config.devenv.shell;
      };
    };
  };
}
