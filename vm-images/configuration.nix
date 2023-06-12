{ config, pkgs, ... }:

{
  system.stateVersion = "22.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    neovim
    wget
    prometheus-node-exporter
    prometheus-process-exporter
  ];
  environment.variables.EDITOR = "nvim";
  # Enable the OpenSSH daemon.
  users.users.root.initialPassword = "root";
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";
  networking.firewall.enable = false;
}
