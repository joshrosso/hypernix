{
  description = "Minimal NixOS installation media";
  inputs = {
    nixos.url = "nixpkgs/23.11";
  };
  outputs = { self, nixos }: {
    nixosConfigurations = {
      iso = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({ pkgs, ... }: {
            environment.systemPackages = [ pkgs.neovim ];
            isoImage.forceTextMode = true;
          })
        ];
      };
    };
  };
}
