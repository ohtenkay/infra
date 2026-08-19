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
            includes = [
              { path = config.age.secrets.git-email.path; }
            ];
            signing = {
              key = "~/.ssh/id_ed25519.pub";
              signByDefault = true;
            };
            settings = {
              user.name = "Ondřej Hložek";
              gpg = {
                format = "ssh";
                ssh = {
                  allowedSignersCommand = "sh -c 'echo \"$1 $(cat ~/.ssh/id_ed25519.pub)\"'";

                };
              };
              init.defaultBranch = "main";
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

          gh = {
            enable = true;
            settings = {
              editor = "nvim";
              # pager = "delta --hunk-header-style=omit --paging=never";
            };
          };

          gh-dash = {
            enable = true;
            settings = {
              editor = "nvim";
              # pager = "delta --hunk-header-style=omit --paging=never";
            };
          };

          lazygit = {
            enable = true;
            settings = {
              git = {
                diffRenderers = [
                  {
                    colorArg = "always";
                    command = "delta --hunk-header-style=omit --paging=never";
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
