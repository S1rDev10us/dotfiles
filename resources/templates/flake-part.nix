{libx}: {lib, ...}: let
  templates = lib.filter (template: template != "flake-part.nix") (libx.listChildren ./.);
in {
  flake = {
    templates = lib.genAttrs templates (template: let
      templateFolder = ./${template};
      templateFlake = templateFolder + "/flake.nix";
    in {
      path = templateFolder;
      description = let
        templateFlakeExists = builtins.pathExists templateFlake;
        placeholderDescription = "Template for ${template}";
      in
        if templateFlakeExists
        then ({description = placeholderDescription;} // import templateFlake).description
        else placeholderDescription;
    });
  };
}
