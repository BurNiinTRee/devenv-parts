{
  description = "An example flake using Devenv-Parts";
  inputs = {
    devenv-parts.url = "github:BurNiinTRee/devenv-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (rootInputs @ {...}: {
      systems = ["x86_64-linux"];
      imports = [inputs.devenv-parts.flakeModules.default];
      perSystem = perSystemInputs @ {...}: {
        devenv.default = devenvInputs @ {...}: {
          services.postgres.enable = true;
          languages.rust.enable = true;
        };
      };
    });
}
