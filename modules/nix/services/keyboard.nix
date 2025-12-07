{lib, ...}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [
        "*"
        # don't apply to ZSA Voyager, it applies most of these in it's own way
        "-3297:1977"
      ];
      settings = {
        main =
          {
            # Use capslock for backspace
            capslock = "backspace";
            # Create the rightalt/nav layer and switch to it when pressing down right alt
            rightalt = "layer(nav)";
          }
          # Disable arrow keys to force to use rightalt + h/j/k/l
          // lib.genAttrs ["left" "down" "up" "right"] (_: "noop");
        # When the nav layer is active then hjkl should turn into arrow keys
        "nav:G" = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          comma = "C-tab";
          m = "C-S-tab";
        };
      };
    };
  };
  services.xserver.xkb.layout = "gb";
  console.keyMap = "uk";
}
