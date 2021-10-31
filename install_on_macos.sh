#!/usr/bin/env bash

# this script can be used to install the newest version of bash (that is the newest version available through homebrew)
# it automatically changes the default shell and sets up a custom .bashrc
# Auther: Valentin Kolb
# Version: 1.0

set -e
set -o pipefail

echo "#######################"
echo "# Installing Homebrew #"
echo "#######################"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update

echo "######################################"
echo "# Installing Programms with Homebrew #"
echo "######################################"
curl -o ~/.config/Brewfile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/config/Brewfile
brew bundle install --file=~/.config/Brewfile
rm ~/.config/Brewfile

echo "##############################"
echo "# Setting up Starship Prompt #"
echo "##############################"
echo "Downloading custom starship.tomml file ..."
mkdir -p ~/.config
curl -o ~/.config/starship.toml https://raw.githubusercontent.com/git/git/master/contrib/completion/config/starship.toml

echo "###################"
echo "# Setting up Bash #"
echo "###################"
if brew ls --versions bash > /dev/null; then
    echo "Upgrading bash ..."
    brew upgrade bash    
fi
bash=$(which -a bash | head -n 1)
echo    "Install location...: " $bash 
echo -n "Bash version.......: "
$bash --version | head -n 1
# append new bash shell to shells file
sudo echo $bash | sudo tee -a /etc/shells
echo "Changing shell for current user and root user ..."
chsh -s $bash
sudo chsh -s $bash
echo "Downloading scripts used for the git status in the prompt ..."
sudo mkdir -p /etc/bash_completion.d
sudo curl -o /etc/bash_completion.d/git-completion https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
sudo curl -o /etc/bash_completion.d/git-prompt https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
echo "Downlaoding custom .bashrc ..."
curl -o ~/.bashrc https://raw.githubusercontent.com/ValentinKolb/bashrc/main/config/.bashrc
if [[ -f "~/.profile" ]]; then
    read -p "Do you want also want to replace the '~/.profile' file? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        rm ~/.profile
        curl -o ~/.profile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/config/.profile
    else
        echo "Ok. Please make sure to load the ~/.bashrc in your ~/.profile file."
    fi
else
    curl -o ~/.profile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/config/.profile
fi

echo "###############################"
echo "# Setting defaults (Settings) #"
echo "###############################"

# show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# set default finder folder to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# disable sleep
sudo systemsetup -setcomputersleep Never

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: swipe between pages with three fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

echo "Instalation complete. Please restart your shell now."