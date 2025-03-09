#!/bin/bash

# Update dnf.conf to enable faster downloads
echo "Configuring DNF settings..."
sudo tee -a /etc/dnf/dnf.conf <<EOF
max_parallel_downloads=10
fastestmirror=true
EOF

# Update and upgrade system
echo "Updating and upgrading system..."
sudo dnf update -y && sudo dnf upgrade -y

# Install essential tools
echo "Installing essential tools..."
sudo dnf install -y grub-customizer gnome-tweaks timeshift

# Refresh and update firmware
echo "Refreshing firmware updates..."
sudo fwupdmgr refresh --force
sudo fwupdmgr update

# Enable RPM Fusion repositories
echo "Enabling RPM Fusion repositories..."
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Refresh system upgrades
echo "Refreshing system upgrades..."
sudo dnf upgrade --refresh -y

# Install Flatpak Extension Manager
echo "Installing Flatpak Extension Manager..."
flatpak install -y flathub com.mattjakeman.ExtensionManager

# Install multimedia and utility packages
echo "Installing multimedia and utility packages..."
sudo dnf install -y mpv vlc unrar unzip python3-pip cargo p7zip ntfs-3g gedit

#Install fastfetch, the neofetch alternative
echo "Installing fastfetch..."
sudo dnf install fastfetch -y #run fastfetch in the terminal to see the system information

# Install software from GNOME Software Center
echo "Installing software from GNOME Software Center..."
FLATPAK_APPS=(
    "com.google.Chrome"
    "com.visualstudio.code"
    "fr.handbrake.ghb"
    "com.adobe.Reader"
    "com.spotify.Client"
    "com.discordapp.Discord"
    # Zen browser
    "com.github.wwmm.easyeffects"
    # Kitty terminal
    "org.nickvision.tubeconverter" # Parabolic
)

for APP in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$APP"
done

# Install software from GitHub repositories
echo "Installing software from GitHub repositories..."
GITHUB_REPOS=(
    "https://github.com/josueBarretogit/manga-tui/releases/download/v0.6.0/manga-tui-0.6.0-x86_64-unknown-linux-gnu.tar.gz" #cd to Downloads/manga-tui folder then run ./manga-tui for the app to run
    "https://github.com/Beastwick18/nyaa/releases/download/v0.9.1/nyaa-0.9.1-1.x86_64.rpm" #just run the nyaa command in the terminal
    "https://github.com/th-ch/youtube-music/releases/download/v3.7.5/youtube-music-3.7.5.x86_64.rpm" #Installs the youtube music mod
)

for REPO in "${GITHUB_REPOS[@]}"; do
    if [[ "$REPO" == *.rpm ]]; then
        wget "$REPO" -P ~/Downloads/
        sudo dnf install -y ~/Downloads/$(basename "$REPO")
    else
        git clone "$REPO" ~/Downloads/$(basename "$REPO" .git)
        cd ~/Downloads/$(basename "$REPO" .git)
        if [ -f "install.sh" ]; then
            chmod +x install.sh
            ./install.sh
        elif [ -f "setup.sh" ]; then
            chmod +x setup.sh
            ./setup.sh
        fi
        cd ~
    fi
done

# Install ani-cli and enter ani-cli to run the application
echo "Installing ani-cli..."
sudo dnf copr enable derisis13/ani-cli -y && sudo dnf install ani-cli -y

# Install the cava audio visualizer and enter the cava command in the terminal to run the application
echo "Installing cava audio visualizer..."
sudo dnf install cava -y

# Install GNOME Shell extensions using gnome-shell-extension-installer
echo "Installing GNOME Shell extensions..."
curl -sSL "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer" -o /usr/local/bin/gnome-shell-extension-installer
chmod +x /usr/local/bin/gnome-shell-extension-installer

EXTENSION_IDS=(
    19   # User Themes
    517  # Caffeine
    6682 # Astra Monitor
    5446 # Quick Settings Tweaker
    4491 # Privacy Quick Settings
    4451 # Logo Menu
    3193 # Blur My Shell
    6784 # Wiggle
    277  # Impatience
    307  # Dash to Dock
    97   # Coverflow Alt-Tab
    3740 # Compiz Alike Magic Lamp Effect
    4648 # Desktop Cube
    3956 # Fuzzy App Search
    1319 # GSConnect
    4470 # Media Controls
    5489 # Search Light
)

for EXT_ID in "${EXTENSION_IDS[@]}"; do
    gnome-shell-extension-installer "$EXT_ID" --yes
done
echo "GNOME Shell extensions installation complete."

# Compile schemas for installed GNOME extensions
echo "Compiling schemas for installed GNOME extensions..."
for DIR in ~/.local/share/gnome-shell/extensions/*/schemas; do
    if [ -d "$DIR" ]; then
        glib-compile-schemas "$DIR"
    fi
done
echo "GNOME Shell extensions compilation complete."

# Prompt user for reboot
echo "System setup is complete. It is recommended to reboot now."
read -p "Do you want to reboot now? (y/N): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Reboot skipped. Please reboot manually later for changes to take full effect."
fi
