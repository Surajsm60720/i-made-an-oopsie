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
    "fr.handbrake.ghb"
    "com.spotify.Client"
    "com.discordapp.Discord"
    "com.github.wwmm.easyeffects"
    "org.nickvision.tubeconverter" # Parabolic
)

for APP in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$APP"
done

# Install VS Code using RPM package
echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
sudo dnf install code # or code-insiders

# Install kitty terminal
echo "Installing kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
mkdir ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
echo "Docker and Docker Compose installation complete."
# Run sudo docker run hello-world to verify the installation

# Install Latex components and dependencies
echo "Installing Latex components and dependencies..."
sudo dnf install latexmk latexindent synctex chktex -y
sudo dnf install texlive-collection-latex texlive-collection-latexrecommended texlive-collection-latexextra texlive-collection-fontsrecommended texlive-collection-fontsextra texlive-collection-langenglish texlive-collection-langgerman texlive-collection-langfrench texlive-collection-langspanish texlive-collection-langportuguese texlive-collection-langitalian texlive-collection-langcjk
echo "Latex components and dependencies installation complete."
    
# Install software from GitHub repositories
echo "Installing software from GitHub repositories..."
GITHUB_REPOS=(
    "https://github.com/josueBarretogit/manga-tui/releases/download/v0.7.0/manga-tui-0.7.0-x86_64-unknown-linux-gnu.tar.gz" #cd to Downloads/manga-tui folder then run ./manga-tui for the app to run
    "https://github.com/Beastwick18/nyaa/releases/download/v0.9.1/nyaa-0.9.1-1.x86_64.rpm" #just run the nyaa command in the terminal
    "https://github.com/th-ch/youtube-music/releases/download/v3.8.0/youtube-music-3.8.0.x86_64.rpm" #Installs the youtube music mod
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

echo "The following GNOME Shell extensions will be installed:"
echo "1. User Themes"
echo "2. Caffeine"
echo "3. Astra Monitor"
echo "4. Quick Settings Tweaker"
echo "5. Privacy Quick Settings"
echo "6. Logo Menu"
echo "7. Blur My Shell"
echo "8. Wiggle"
echo "9. Impatience"
echo "10. Dash to Dock"
echo "11. Coverflow Alt-Tab"
echo "12. Compiz Alike Magic Lamp Effect"
echo "13. Desktop Cube"
echo "14. Fuzzy App Search"
echo "15. GSConnect"
echo "16. Media Controls"
echo "17. Search Light" 

echo "Do you want to continue with the installation of these extensions? (y/N): "
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "GNOME Shell extensions installation skipped."
    exit
fi

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

# Installing additional components for the extensions
echo "Installing additional components for the extensions..."
sudo dnf install nethogs -y
sudo dnf install iotop -y
sudo dnf install openssl -y

# Installing oh-my-zsh
# Check out https://github.com/novaspirit/pimpyourterm for any queries
echo "Installing oh-my-zsh..."
sudo dnf install zsh -y
chsh -s $(which zsh)
echo "Reopen the terminal to see the changes"
echo "Press 0 and then 1"
echo "Run the ./oh-my-zsh.sh script to install oh-my-zsh" 

# Prompt user for reboot
echo "System setup is complete. It is recommended to logout and login again to see the changes."
read -p "Do you want to logout now? (y/N): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Logging out now..."
    gnome-session-quit --logout --no-prompt
else
    echo "Logout skipped. Please logout and login manually later for changes to take full effect."
fi
