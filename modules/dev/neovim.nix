{ ... }:
{
  flake.modules.nixos.neovim =
    { pkgs, ... }:
    {
      home-manager.users.ondrej.xdg.configFile."nvim".source = ../../external-configs/nvim;

      environment.systemPackages = with pkgs; [
        neovim
        stylua

        wget
        ripgrep
        fd

        gcc
        tree-sitter
        unzip
        zip
        lua-language-server
      ];

      environment.variables.EDITOR = "nvim";
    };
}
