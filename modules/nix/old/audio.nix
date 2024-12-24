{lib, ...}: {
  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false; # This conflicts with the import in cerberus, I need to just pull in the config in that input so I don't need to do this here
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
