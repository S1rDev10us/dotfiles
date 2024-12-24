{
  plugins = {
    neo-tree = {
      enable = true;
      window = {
        mappings = {
          "<Space>" = "none";
          "s" = "none";
          "l" = "child_or_open";
          "h" = "parent_or_close";
        };
      };
    };
    which-key = {
      enable = true;
    };
  };
  keymaps = [
    {
      action = "<cmd>Neotree toggle<CR>";
      key = "<Leader>e";
      options = {silent = true;};
    }
  ];
  globals.mapleader = " ";
  autoCmd = [
    {
      command = "Neotree";
      event = ["VimEnter"];
    }
  ];
}
