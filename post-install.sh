sudo udevadm control --reload-rules
sudo udevadm trigger

mkdir -p "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins" "$HOME/.wine/drive_c/Program Files/Common Files/VST3" "$HOME/.wine/drive_c/Program Files/Common Files/CLAP" "$HOME/Documents/vsts/dll and vst3 files"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/CLAP"
yabridgectl add "$HOME/Documents/vsts/dll and vst3 files"

echo "Starting yabridge host..."
yabridge-host.exe

yabridgectl sync
yabridgectl status
yabridgectl --version

# https://github.com/whereareiam/noctalia-plugins
# sticky notes plugin in Noctalia v4

WINEPREFIX=~/.wine winetricks dxvk
WINEPREFIX=~/.wine winetricks vcrun6sp6
