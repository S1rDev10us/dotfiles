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
        };
      };
    };
  };
  services.xserver.xkb.layout = "gb,gb";
  services.xserver.xkb.variant = ",colemak";
  services.xserver.xkb.options = "grp:win_space_toggle";
  console.keyMap = "uk";
}
