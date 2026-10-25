{ pkgs, ... }:
{
  packages = with pkgs; [
    terraform
    jq
    git
    openssh
  ];

  scripts.tf = {
    description = "Manage servnix infrastructure and deploy its NixOS configuration";
    exec = ''
      cd "$DEVENV_ROOT/terraform" || exit 1
      exec secretspec run -- terraform "$@"
    '';
  };
}
