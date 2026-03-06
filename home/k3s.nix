{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.features.k3s;
in {
  options.features.k3s = {
    enable = lib.mkEnableOption "Option to enable k3s dependencies";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Install Kubernetes client tools
    {
      home = {
        packages = with pkgs; [
          kubectl
          kubernetes-helm # Helpful for deploying apps
          k9s # Excellent terminal UI for Kubernetes
        ];
      };
    }
    {
      # Point your environment to the system-level kubeconfig created by Ansible
      programs.zsh = {
        envExtra = ''
          export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
        '';
      };
    }
  ]);
}
