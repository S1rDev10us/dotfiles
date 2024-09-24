{
  lib,
  pkgs,
  ...
}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main =
          {
            # Use capslock for backspace
            capslock = "backspace";
            backspace = "noop"; # To stop me from using the old backspace key accidentaly
            # Create the rightalt/nav layer and switch to it when pressing down right alt
            rightalt = "layer(nav)";
          }
          # Disable arrow keys to force to use rightalt + h/j/k/l
          // lib.genAttrs ["left" "down" "up" "right"] (_: "noop");
        # When the nav layer is active then hjkl should turn into arrow keys
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          space = "toggle(colemak)";
        };
      };
      extraConfig = builtins.readFile "${pkgs.keyd}/share/keyd/layouts/colemak";
    };
  };
  services.xserver.xkb.layout = "gb,gb";
  services.xserver.xkb.variant = ",colemak";
  console.keyMap = "uk";
}
