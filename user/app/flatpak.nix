{ pkgs, inputs,... }:

{  

  home.packages = [ pkgs.flatpak ];
  home.sessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"; # lets flatpak work
  };

  services.flatpak.enable = true;
  services.flatpak.update.onActivation = true;
  services.flatpak.packages = [ { appId = "org.videolan.VLC"; origin = "flathub";  } 
  "com.rtosta.zapzap"
  #"com.spotify.Client"
  "app.zen_browser.zen"
  "org.gtk.Gtk3theme.Adwaita-dark"
  "com.mattjakeman.ExtensionManager"
  "com.usebottles.bottles"
  #"org.flameshot.Flameshot"
  "org.kicad.KiCad"
  "org.kde.kdenlive"
  "org.leocad.LeoCAD"
  "com.github.reds.LogisimEvolution"
  "io.github.huderlem.porymap"
  "com.github.finefindus.eyedropper"
  "org.gnome.meld"
  "org.qbittorrent.qBittorrent"
  "it.mijorus.gearlever"
  "com.github.flxzt.rnote"
  ];
  
  # Configuration file for Spotify flags
  #home.file = {
  #  ".var/app/com.spotify.Client/config/spotify-flags.conf".text = ''
  #    --ozone-platform=x11
  #    --disable-features=UseOzonePlatform
  #  '';
  #};
  
  #services.flatpak.update.onActivation = true;
}

