{ ... }:
{
  flake.modules.nixos.shell =
    { flakeRoot, pkgs, ... }:
    {
      home-manager.users.ondrej =
        { config, ... }:
        {
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            shellAliases = {
              nrs = "sudo nixos-rebuild switch --flake path:/home/ondrej/infra";
              nfu = "nix flake update --flake path:/home/ondrej/infra";
            };
            initContent = ''
              eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/config.toml)"
            '';
          };

          programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
            options = [ "--cmd cd" ];
          };

          xdg.configFile."ohmyposh/config.toml".source =
            config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/external-configs/ohmyposh.toml";
        };

      environment.systemPackages = with pkgs; [
        oh-my-posh
      ];
    };
}
