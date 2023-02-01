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
              modules = [
                mod
                ({...}: {
                  options.devShellAttribute = lib.mkOption {
                    description = lib.mdDoc ''
                      The attribute name under `devShells` where the devenv shell
                      will appear.

                      Set to `null` to disable.
                    '';
                    type = lib.types.nullOr lib.types.str;
                    default = "default";
                  };
                })
              ];
            };
          default = {};
        };
        config.devShells = lib.mkIf (!builtins.isNull config.devenv.devShellAttribute) {
          ${config.devenv.devShellAttribute} = config.devenv.shell;
        };
      };
    };
    templates.simple = {
      path = ./examples/simple;
      description = "simple devenv-parts flake";
    };
    templates.default = self.templates.simple;
  };
}
