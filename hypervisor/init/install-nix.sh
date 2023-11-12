ssh root@${NIXADDR} " \
    nixos-generate-config --root /mnt; \
    sed --in-place '/system\.stateVersion = .*/a \
      nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
      services.openssh.enable = true;\n \
      services.openssh.passwordAuthentication = true;\n \
      services.openssh.permitRootLogin = \"yes\";\n \
      users.users.root.initialPassword = \"root\";\n \
    ' /mnt/etc/nixos/configuration.nix; \
    nixos-install --no-root-passwd; \
 "
