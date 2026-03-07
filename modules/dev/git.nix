{ ... }:
{
  flake.modules.nixos.dev = {
    home-manager.users.ondrej =
      { config, ... }:

      {
        age.secrets.git-email.file = ../../secrets/git-email.age;

        programs = {
          git = {
            enable = true;
            settings.user.name = "Ondřej Hložek";
            includes = [
              { path = config.age.secrets.git-email.path; }
            ];
            signing = {
              key = "~/.ssh/id_ed25519.pub";
              signByDefault = true;
            };
            settings = {
              gpg.format = "ssh";
              gpg.ssh.allowedSignersCommand = "sh -c 'echo \"$1 $(cat ~/.ssh/id_ed25519.pub)\"'";
            };
          };

          delta = {
            enable = true;
            enableGitIntegration = true;
            options = {
              syntax-theme = "base16-stylix";
              line-numbers = true;
            };
          };

          lazygit = {
            enable = true;
            settings = {
              git = {
                pagers = [
                  {
                    colorArg = "always";
                    pager = "delta --hunk-header-style=omit --paging=never";
                  }
                ];
                overrideGpg = true;
              };
            };
          };

          bat.enable = true;
        };
      };
  };
}
