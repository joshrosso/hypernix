# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ self, config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.extraOptions = "experimental-features = nix-command flakes";
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";

  environment.systemPackages = with pkgs; [
    neovim
    git
    nmap
    pciutils
    ripgrep
  ];

  users.users.root.initialPassword = "root";
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVyzpM8KL8OWXwC2Lcpe49zMdDGqQ8EQiygJSXmWqtGLw9We29/EAA5se7tvUzjgcTWZN/FFWl59Ba4QYJlRREPSuBy1M1urErR0elrfSNf1ORVNKINlWydDW57wg2/OW9hId1cvjaCha4GCt6gc+0ohRBG3wKBALUMMRcsvmOdRvHrKcIt5FIYdrl5vtKhxW5sj+uBZOjznj5ocAcwQ1u/EC7hzSucVrSdXT2ZCOapHBB6HVbxituQ5FQJn4OcW4sOdZPP0nbNlpX52IzlfBYO8JI4nx3d2qvBx4QRyrd8eRk/6B6U7iVATDuQgTyWcrmYtsi8ljmTcFM0xdiYA+3"
    ];
  };
}
