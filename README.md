# Devenv-Parts

This flake exposes a [Flake-Parts] module to easily use a [Devenv] shell.

To use, simply set `perSystem.devenv` to your [Devenv] module.


## Example
```nix
# flake.nix
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

```

Then run
```bash
$ nix develop --impure
```
to enter the environment.

Alternatively put
```bash
use flake --impure
```
into your `.envrc` when using [Direnv].





[Flake-Parts]: https://flake.parts
[Devenv]: https://devenv.sh
[Direnv]: https://direnv.net