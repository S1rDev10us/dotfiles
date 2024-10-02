{...}: {
  home.sessionVariables.TERMINAL = "foot";
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetbrainsMonoNF:size=10";
        };
        colors = {
          alpha = 0.0;
        };
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
