{ ... }:
{
  flake.modules.nixos.nordvpn-desktop = {
    home-manager.users.ondrej = {
      home.file.".local/share/applications/nordvpn.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=NordVPN CLI
        Comment=Handles NordVPN browser login callbacks
        Exec=nordvpn login --callback %u
        MimeType=x-scheme-handler/nordvpn;
        NoDisplay=true
        Terminal=false
      '';
    };
  };
}
