{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          # When holding down capslock instead press meta and when tapping/releasing it press escape
          capslock = "overload(meta,esc)";
          # Create the rightalt layer and switch to it when pressing down right alt
          rightalt = "layer(rightalt)";
        };
        # When the rightalt layer (defined above) is pressed then hjkl should turn into arrow keys
        rightalt = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };
}
