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
      exec terraform -chdir="$DEVENV_ROOT/terraform" "$@"
    '';
  };
}
