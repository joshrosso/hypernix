{ config, pkgs, ... }:

{

  users.motd = "Hello Kubecon Amsterdam!!!";

  networking.hostName = "";
  system.stateVersion = "23.05";

  virtualisation.containerd = {
        enable = true;
        configFile = ./containerd-config.toml;
  };


  # kernel modules and settings required by Kubernetes
  boot.kernelModules = [ "overlay" "br_netfilter" ];
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.ipv4.ip_forward" = 1;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    ripgrep
    prometheus-node-exporter
    prometheus-process-exporter
    kubernetes
    containerd
    cri-tools

    ebtables
    ethtool
    socat
    iptables
    conntrack-tools
    (import ./hostname.nix)
  ];


  systemd.services.kubelet = {
    enable = true;
    description = "kubelet";
    serviceConfig = {
      ExecStart = "${pkgs.kubernetes}/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS";
      Environment = [
        "\"KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf\""
        "\"KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml\""
        "PATH=/run/wrappers/bin:/root/.nix-profile/bin:/etc/profiles/per-user/root/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      ];
      EnvironmentFile = [
        "-/var/lib/kubelet/kubeadm-flags.env"
        "-/etc/default/kubelet"
      ];
      Restart = "always";
      StartLimitInterval = 0;
      RestartSec = 10;
    };
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

  systemd.services.hostname-init = {
    enable = true;
    description = "set the hostname to the IP";
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/hostname-init";
    };
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

  environment.variables.EDITOR = "nvim";

  # Enable the OpenSSH daemon.
  users.users.root.initialPassword = "root";
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";
  networking.firewall.enable = false;

}

