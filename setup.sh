#!/usr/bin/env bash

# this scripts sets up bash and a fancy prompt with git status
# Auther: Valentin Kolb
# Version: 1.0


set -e
set -o pipefail

echo "Changing shell for current user ..."
chsh -s $bash

echo "Downloading scripts used for the git status in the prompt ..."
sudo mkdir -p /etc/bash_completion.d
sudo curl -o /etc/bash_completion.d/git-completion https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
sudo curl -o /etc/bash_completion.d/git-prompt https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

echo "Downlaoding custom .bashrc ..."
curl -o ~/.bashrc https://raw.githubusercontent.com/ValentinKolb/bashrc/main/.bashrc

if [[ -f "~/.profile" ]]; then
    read -p "Do you want also want to replace the '~/.profile' file? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm ~/.profile
        curl -o ~/.profile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/.profile
    else
        echo "Ok. Please make sure to load the ~/.bashrc in your ~/.profile file."
    fi
else
    curl -o ~/.profile https://raw.githubusercontent.com/ValentinKolb/bashrc/main/.profile
fi

echo "Setup complete. Please restart your shell now."
