{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { ... }:
    {
      programs.umbriel.enable = true;

      home-manager.users.ondrej = {
        imports = [ inputs.umbriel.homeModules.default ];

        programs.umbriel = {
          enable = true;
          settings = {
            keybinds = {
              "Mod+Slash" = "cheatsheet-toggle";
            };
          };
        };
      };
    };
}
