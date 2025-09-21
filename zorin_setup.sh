#/bin/bash

# Zorin OS setup script
echo "Setting up Zorin OS..."
sudo apt update -y && sudo apt upgrade -y

# Install essential tools
echo "Installing essential tools..."
sudo apt install -y gnome-tweaks timeshift git

# Refresh system upgrades
echo "Refreshing system upgrades..."
sudo apt upgrade --refresh -y

# Install Flatpak Extension Manager
echo "Installing Flatpak Extension Manager..."
flatpak install -y flathub com.mattjakeman.ExtensionManager

# Install multimedia and utility packages
echo "Installing multimedia and utility packages..."
sudo apt install -y mpv vlc unrar unzip python3-pip cargo p7zip-full ntfs-3g gedit

# Install Neofetch
echo "Installing Neofetch..."
sudo apt install neofetch

# If Neofetch does not work then uncomment this to install Fastfetch
# echo "Installing Fastfetch..."
# sudo apt install fastfetch

# Install additional codecs
echo "Installing Ubuntu Restricted Extras..."
sudo apt install -y ubuntu-restricted-extras

# Install Preload
echo "Installing Preload..."
sudo apt install -y preload

# Install TLP
echo "Installing tlp..."
sudo apt install -y tlp

# Install LaTeX packages
echo "Installing LaTeX packages..."
sudo apt install latexmk chktex -y
sudo apt install texlive -y
sudo apt-get install texlive-latex-extra -y
sudo apt-get install texlive-bibtex-extra -y
sudo apt-get install texlive-bibtex-extra biber -y
sudo apt-get install texlive-fonts-extra -y

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

# Install Cava - audio visualizer
echo "Installing Cava..."
sudo apt install -y cava

# Install software from GitHub repositories
echo "Installing software from GitHub repositories..."
GITHUB_REPOS=(
    "https://github.com/josueBarretogit/manga-tui/releases/download/v0.7.0/manga-tui-0.7.0-x86_64-unknown-linux-gnu.tar.gz" #cd to Downloads/manga-tui folder then run ./manga-tui for the app to run
    "https://github.com/Beastwick18/nyaa/releases/download/v0.9.1/nyaa-0.9.1-x86_64-unknown-linux-gnu" #just run the nyaa command in the terminal
    "https://github.com/th-ch/youtube-music/releases/download/v3.10.0/youtube-music-3.10.0.tar.gz" #Installs the youtube music mod
)

for REPO in "${GITHUB_REPOS[@]}"; do
    if [[ "$REPO" == *.rpm ]]; then
        wget "$REPO" -P ~/Downloads/
        sudo apt install -y ~/Downloads/$(basename "$REPO")
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

# # Install GNOME Shell extensions using gnome-shell-extension-installer
# echo "Installing GNOME Shell extensions..."
# curl -sSL "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer" -o /usr/local/bin/gnome-shell-extension-installer
# chmod +x /usr/local/bin/gnome-shell-extension-installer

# echo "The following GNOME Shell extensions will be installed:"
# echo "4. Quick Settings Tweaker"
# echo "5. Privacy Quick Settings"
# echo "14. Fuzzy App Search"
# echo "15. GSConnect"
# echo "17. Search Light" 

# echo "Do you want to continue with the installation of these extensions? (y/N): "
# read -r response
# if [[ ! "$response" =~ ^[Yy]$ ]]; then
#     echo "GNOME Shell extensions installation skipped."
#     exit
# fi

# EXTENSION_IDS=(
#     5446 # Quick Settings Tweaker
#     4491 # Privacy Quick Settings
#     3956 # Fuzzy App Search
#     1319 # GSConnect
#     5489 # Search Light
# )

# for EXT_ID in "${EXTENSION_IDS[@]}"; do
#     gnome-shell-extension-installer "$EXT_ID" --yes
# done
# echo "GNOME Shell extensions installation complete."

# # Compile schemas for installed GNOME extensions
# echo "Compiling schemas for installed GNOME extensions..."
# for DIR in ~/.local/share/gnome-shell/extensions/*/schemas; do
#     if [ -d "$DIR" ]; then
#         glib-compile-schemas "$DIR"
#     fi
# done
# echo "GNOME Shell extensions compilation complete."

# # Installing additional components for the extensions
echo "Installing additional components for the extensions..."
sudo apt install nethogs -y
sudo apt install iotop -y
sudo apt install openssl -y
sudo apt install htop -y

# VS Code can be installed using the official website .deb package
# Zen browser too can be installed from the official website
# For brave browser gesture navigations, cd /usr/share/applications/brave-browser.desktop
# go to the exec= line that has %U at the end and replace that line with this
# Exec=/usr/bin/brave-browser-stable --enable-features=TouchpadOverscrollHistoryNavigation,UseOzonePlatform --ozone-platform=wayland
# then ctrl+o enter ctrl+x
# go to the CLI in VS Code and to any repo and type git config user.name "Your Name"
# then git config user.email "you@example.com"