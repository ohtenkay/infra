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
            defaultKeymap = "viins";
            shellAliases = {
              nrs = "sudo nixos-rebuild switch --flake path:/home/ondrej/infra";
              nrs-servnix = "NIX_SSHOPTS='-i /home/ondrej/.ssh/id_ed25519_servnix' nixos-rebuild switch --flake path:${flakeRoot}#servnix --target-host root@2.31.56.62";
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
