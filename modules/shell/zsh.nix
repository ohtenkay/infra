{ ... }:
{
  flake.modules.nixos.shell =
    { pkgs, ... }:
    {
      home-manager.users.ondrej = {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          defaultKeymap = "viins";
          shellAliases = {
            nrs = "nixos-rebuild switch --flake path:/home/ondrej/infra --sudo";
            nfu = "nix flake update --flake path:/home/ondrej/infra";
            vpn-fi = "nmcli connection up \"VPN FI MU\" passwd-file ~/.config/vpn/fi-mu.pass";
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

        xdg.configFile."ohmyposh/config.toml".source = ../../external-configs/ohmyposh.toml;
      };

      environment.systemPackages = with pkgs; [
        oh-my-posh
      ];
    };
}
