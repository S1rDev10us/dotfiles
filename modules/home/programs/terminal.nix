{opts, ...}: {
  home.sessionVariables.TERMINAL = "foot";
  programs = {
    foot = {
      enable = opts.GUI;
      settings = {
        main = {
          font = "JetbrainsMonoNF:size=10";
        };
        # colors = {
        #  alpha = 0.0;
        # };
      };
    };
  };
}
