# MitCad: parametric 3D CAD (OCCT kernel, Qt 6). https://github.com/mitcad/Mitcad
#
# Self-updating: MitCad ships near-daily releases, so instead of pinning a version in
# Nix, `mitcad` keeps the official AppImage in ~/.local/share/mitcad-appimage
# (MitCad itself uses ~/.local/share/mitcad for its own data) and updates it
# from the project's own GitHub release manifest:
#   https://github.com/mitcad/Mitcad/releases/latest/download/update-manifest.json
#
#   - First launch: downloads the latest AppImage (with a notification), then starts it.
#   - Every launch: starts the installed version immediately and checks for an update in
#     the background; a new version is used from the next launch.
#   - A daily systemd user timer (see home.nix) also runs `mitcad-update`.
#   - `mitcad-update` updates by hand; `mitcad-update --force` re-downloads.
#
# Every download must match the size and sha256 from that manifest, or it is discarded.
# Only files from github.com/mitcad/Mitcad release URLs are accepted.
# It runs through appimage-run (FHS sandbox), so it doesn't need AppImage binfmt.
{ lib, writeShellApplication, makeDesktopItem, symlinkJoin, fetchurl, runCommand
, appimage-run, curl, jq, coreutils, util-linux, libnotify, procps, findutils }:

let
  update = writeShellApplication {
    name = "mitcad-update";
    runtimeInputs = [ curl jq coreutils util-linux libnotify findutils ];
    text = ''
      manifest_url="https://github.com/mitcad/Mitcad/releases/latest/download/update-manifest.json"
      dir="''${XDG_DATA_HOME:-$HOME/.local/share}/mitcad-appimage"
      force=0 notify=0
      for a in "$@"; do
        case "$a" in
          --force) force=1 ;;
          --notify) notify=1 ;;  # used for the first-run download from the launcher
          *) echo "usage: mitcad-update [--force]" >&2; exit 2 ;;
        esac
      done
      say() { echo "mitcad-update: $*" >&2; if [ "$notify" = 1 ]; then notify-send -a MitCad -i mitcad "MitCad" "$*" || true; fi; }

      mkdir -p "$dir"
      exec 9>"$dir/.lock"
      flock -n 9 || { echo "mitcad-update: another update is running" >&2; exit 0; }

      manifest=$(curl -fsSL --retry 2 --max-time 30 "$manifest_url") \
        || { say "could not fetch the update manifest (offline?)"; exit 1; }
      version=$(jq -er '.manifest.version' <<<"$manifest")
      url=$(jq -er '.manifest.assets."linux-x64".url' <<<"$manifest")
      sha=$(jq -er '.manifest.assets."linux-x64".sha256' <<<"$manifest")
      size=$(jq -er '.manifest.assets."linux-x64".size' <<<"$manifest")

      [[ "$version" =~ ^[0-9]+(\.[0-9]+)*$ ]] || { say "bad version '$version' in manifest"; exit 1; }
      [[ "$sha" =~ ^[0-9a-f]{64}$ ]] || { say "bad sha256 in manifest"; exit 1; }
      case "$url" in
        https://github.com/mitcad/Mitcad/releases/download/*) ;;
        *) say "refusing download from unexpected URL: $url"; exit 1 ;;
      esac

      file="$dir/Mitcad-$version-x86_64.AppImage"
      if [ "$force" = 0 ] && [ -f "$file" ] && [ "$(readlink "$dir/current.AppImage" || true)" = "$(basename "$file")" ]; then
        echo "mitcad-update: $version is already installed" >&2
        exit 0
      fi

      say "downloading MitCad $version…"
      tmp="$file.part"
      trap 'rm -f "$tmp"' EXIT
      if [ -t 2 ]; then progress=(--progress-bar); else progress=(-sS); fi
      curl -fL "''${progress[@]}" --retry 3 --max-time 1800 -o "$tmp" "$url" || { say "download failed"; exit 1; }

      [ "$(stat -c %s "$tmp")" = "$size" ] || { say "size mismatch, discarded"; exit 1; }
      echo "$sha  $tmp" | sha256sum -c --quiet - || { say "sha256 mismatch, discarded"; exit 1; }

      chmod 755 "$tmp"
      mv -f "$tmp" "$file"
      echo "$sha" > "$file.sha256"
      ln -sfn "$(basename "$file")" "$dir/current.AppImage"
      say "MitCad $version installed"
    '';
  };

  launcher = writeShellApplication {
    name = "mitcad";
    runtimeInputs = [ appimage-run coreutils util-linux procps findutils libnotify update ];
    text = ''
      dir="''${XDG_DATA_HOME:-$HOME/.local/share}/mitcad-appimage"
      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/appimage-run"
      current="$dir/current.AppImage"

      if [ ! -e "$current" ]; then
        mitcad-update --notify || exit 1
      else
        # Check for a newer release without delaying startup.
        setsid -f mitcad-update >/dev/null 2>&1 < /dev/null || true
      fi

      # Remove older versions (and appimage-run's extracted copy of them; that cache dir
      # is named by the AppImage's sha256) unless that version is still running.
      cur=$(readlink "$current")
      for old in "$dir"/Mitcad-*-x86_64.AppImage; do
        [ -e "$old" ] || continue
        [ "$(basename "$old")" = "$cur" ] && continue
        sha=$(cat "$old.sha256" 2>/dev/null || true)
        if [ -n "$sha" ] && pgrep -f "appimage-run/$sha" >/dev/null; then continue; fi
        [ -n "$sha" ] && rm -rf "''${cache:?}/$sha"
        rm -f "$old" "$old.sha256"
      done

      exec appimage-run "$dir/$cur" "$@"
    '';
  };

  # Official app icon from the MitCad repo (pinned commit).
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/mitcad/Mitcad/07cae41a440ff8ae2431d3c404b3f8c5b8bcef08/app/packaging/icon/mitcad.svg";
    hash = "sha256-FMrsKc4oTK4pbm9F+14LnBcCxqLEPfLMHqtflidngcw=";
  };

  # Same fields as the .desktop file inside the AppImage.
  desktop = makeDesktopItem {
    name = "mitcad";
    desktopName = "MitCad";
    genericName = "Parametric CAD";
    comment = "Parametric 3D CAD with a design history";
    exec = "mitcad %F";
    icon = "mitcad";
    startupWMClass = "Mitcad";
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    keywords = [ "CAD" "3D" "model" "parametric" "sketch" ];
  };

  icons = runCommand "mitcad-icon" { } ''
    install -Dm644 ${icon} $out/share/icons/hicolor/scalable/apps/mitcad.svg
  '';
in
symlinkJoin {
  name = "mitcad-launcher";
  paths = [ launcher update desktop icons ];
  passthru = { inherit update; };
  meta = {
    description = "Self-updating launcher for the official MitCad AppImage";
    homepage = "https://github.com/mitcad/Mitcad";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mitcad";
  };
}
