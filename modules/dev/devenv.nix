{ ... }:
{
  flake.modules.nixos.dev = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      devenv
    ];

    home-manager.users.ondrej.programs.zsh.initContent = ''
      eval "$(devenv hook zsh)"
    '';
  };
}
