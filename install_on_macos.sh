#!/usr/bin/env bash

# this script can be used to install the newest version of bash (that is the newest version available through homebrew)
# it automatically changes the default shell and sets up a custom .bashrc
# Auther: Valentin Kolb
# Version: 1.0

set -e
set -o pipefail

brew update

if brew ls --versions bash > /dev/null; then
    echo "Upgrading bash ..."
    brew upgrade bash    
else
    echo "Installing bash ..."
    brew install bash
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
sudo curl -o /etc/bash_completion.d/git-completion https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
sudo curl -o /etc/bash_completion.d/git-prompt https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

echo "Downlaoding custom .bashrc ..."
curl -o ~/.bashrc https://raw.githubusercontent.com/ValentinKolb/bashrc/main/.bashrc

read -p "Do you want also want to replace the '~/.profile' file? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    rm ~/.profile
    curl -o ~/.profile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/.profile
else
    echo "Ok. Please make sure to load the ~/.bashrc in your ~/.profile file."
fi

echo "Instalation complete. Please restart your shell now."