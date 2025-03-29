{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    8001 # k3s proxy port
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s = {
    enable = true;
    role = "server";
  };
}
