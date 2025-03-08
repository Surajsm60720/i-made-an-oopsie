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
    "https://github.com/th-ch/youtube-music/releases/download/v3.7.5/youtube-music-3.7.5.x86_64.rpm"
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
echo "Installing ani-cli"
sudo dnf copr enable derisis13/ani-cli -y && sudo dnf install ani-cli -y

# Install the cava audio visualizer and enter the cava command in the terminal to run the application
sudo dnf install cava -y


# Install GNOME Shell extensions
# echo "Installing GNOME Shell extensions..."
# EXTENSIONS=(
    # "user-themes@gnome-shell-extensions.gcampax.github.com"
    # "caffeine@patapon.info"
    # "astra-monitor@evermiss.net"
    # "quick-settings-tweaker@qwreey"
    # "privacy-quick-settings@privacy"
    # "logo-menu@carlos-ramirez"
    # "blur-my-shell@aunetx"
    # "wiggle@unredactor"
    # "impatience@gfxmonk.net"
    # "dash-to-dock@micxgx.gmail.com"
    # "coverflow-alt-tab@palatis.github.com"
    # "compiz-alike-magic-lamp-effect@hermes83"
    # "desktop-cube@zhanghai"
    # "fuzzy-app-search@yourusername"
    # "gsconnect@andyholmes.github.io"
    # "media-controls@cliffniff.github.io"
    # "search-light@user-extensions"
# )

# for EXT in "${EXTENSIONS[@]}"; do
    # gnome-extensions install "https://extensions.gnome.org/extension-data/$EXT.zip"
    # gnome-extensions enable "$EXT"
# done

# Prompt user for reboot
echo "System setup is complete. It is recommended to reboot now."
read -p "Do you want to reboot now? (y/N): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Reboot skipped. Please reboot manually later for changes to take full effect."
fi
