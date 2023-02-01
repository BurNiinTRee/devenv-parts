{
  inputs = {
    devenv.url = "github:cachix/devenv";
  };

  outputs = {
    self,
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
          type = lib.types.deferredModule;
          description = ''
            See [devenv's documentation](https://devenv.sh/reference/options/) for details.
          '';
          apply = mod:
            devenv.lib.mkConfig
            {
              inherit pkgs inputs;
              modules = [mod];
            };
          default = {};
        };
        config.devShells.default = config.devenv.shell;
      };
    };
    templates.simple = {
      path = ./examples/simple;
      description = "simple devenv-parts flake";
    };
    templates.default = self.templates.simple;
  };
}
