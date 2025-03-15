A bash script that installs all my mostly used apps, git repos and extensions for Gnome.

Why I made it you ask? Well, I am prone to making my Linux system go down the drains by doing things I clearly shouldn't. 

## Getting started


1. Clone the repository:
   ```bash
    git clone https://github.com/Surajsm60720/i-made-an-oopsie.git
   ```
   Or simply download the file.

2. Run the fedora-setup script:
   ```bash
   ./fedora-setup.sh
   ```
   If you downloaded the file, then:
   ```bash
   cd Downloads/i-made-an-oopsie
   ./fedora-setup.sh
   ```

3. Run the oh-my-zsh script if needed:
   ```bash
   ./oh-my-zsh.sh
   ```

And there you go, all the files, applications, extensions, etc. are now installed.

## What does my script install??

Firstly, the script runs the update and upgrade commands after setting up dnf.conf file to maximize my download speeds using the package manager.
Then, the firmwares are upgraded and RPM fusion repos are added.

Let's start with the applications...

- grub-customizer
- timeshift 
- gnome-tweaks 
- [Extension Manager](https://github.com/mjakeman/extension-manager)

These are like the most important tools for my smooth Linux experience.

Other applications include, 

- Fastfetch (RIP neofetch)
- VLC media player (the GOAT)
- python3-pip (obviously)
- mpv (its just there)

And some more (read the utility packages part of the ./fedora-setup.sh file).

### Flatpak applications 

Yes, I use flatpak to install some of the applications like, 

- Chrome
- Handbrake (video and audio encoder type app)
- Spotify
- Discord
- Adobe Reader (very old ver.)
- Easy Effects (better audio output with plugins)
- Parabolic (abslute chad video downloader)

VS Code is installed using the RPM package because Flatpak has issues with zsh.<br>
Kitty terminal installation is done seperately by another set of commands.<br>
Docker is also installed using their respective commands and packages.

### Github repos 

Some github repos that add applications which I can run in my terminal itself

- [manga-tui](https://github.com/josueBarretogit/manga-tui) (Yes, I am a weeb) 
- [ani-cli](https://github.com/pystardust/ani-cli) (Weeb pro max)
- [nyaa](https://github.com/Beastwick18/nyaa) (Torrent site)
- [youtube-music](https://github.com/th-ch/youtube-music) (YT music but with plugins)
- [cava](https://github.com/karlstav/cava) (audio visualizer, way too popular in [r/unixporn](https://www.reddit.com/r/unixporn/?rdt=33730))

### Gnome extensions 

Gnome is never complete for me without some extensions as some of them really change the user experience for the better

Personally, I use the following, 

- User Themes
- Caffeine
- Astra Monitor
- Quick Settings Tweaker
- Privacy Quick Settings
- Logo Menu
- Blur My Shell
- Wiggle
- Impatience
- Dash to Dock
- Coverflow Alt-Tab
- Compiz Alike Magic Lamp Effect
- Desktop Cube
- Fuzzy App Search
- GSConnect
- Media Controls
- Search Light

And finally we have [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), which helps in customizing your shell. 

For any doubts regarding how to run some files or stuck anywhere, check the code comments :)