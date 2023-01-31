self: {inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.devenv = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [
          (self.inputs.devenv.modules + /top-level.nix)
          ({
            config,
            pkgs,
            ...
          }: {
            packages = [
              (import (self.inputs.devenv + /src/devenv-devShell.nix) {inherit config pkgs;})
            ];
            devenv.warnOnNewVersion = false;
            devenv.flakesIntegration = true;
            # devenv.cliVersion = "0.5";
          })
          {
            _module.args.pkgs = pkgs;
            _module.args.inputs =
              {inherit (self.inputs) pre-commit-hooks;} // inputs;
          }
          {
            _module.args = {inherit (self.inputs) pre-commit-hooks;} // inputs;
          }
        ];
      };
      default = {};
    };
    config.devShells.default = config.devenv.shell;
  };
}
