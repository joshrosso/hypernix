# vm-images

VM images can be producing using `nix-build`. An example command would be:

```sh
nix-build ./nixos-generate.nix \
  --argstr formatConfig formats/qcow.nix \
  -I nixos-config=configuration.nix \
  --no-out-link \
  -A config.system.build.qcow
```
