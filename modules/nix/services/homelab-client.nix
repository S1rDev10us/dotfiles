{
  networking.hosts = {
    # Static IP of Archimedes on home network.
    # :TODO: Add tailscale support
    "192.168.2.206" = ["homelab.home.arpa" "git.homelab.home.arpa" "authentification.home.arpa"];
  };
  security.pki.certificateFiles = [./../../../resources/homelab_CA.crt.pem];
}
