let
  ondrejNixblade = builtins.readFile ../keys/ondrej-nixblade.pub;
in
{
  "git-email.age".publicKeys = [ ondrejNixblade ];
}
