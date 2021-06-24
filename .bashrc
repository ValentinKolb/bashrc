# Auther: Valentin Kolb
# Version 1.0

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

##
# BASH HISTORY
##

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

##
# SET CUSTOM PROMPT
##

# define custom colors
LIGHTGREEN="\033[1;32m"
LIGHTRED="\033[1;31m"
LIGHTYELLOW="\033[1;33m"
RESET="\033[0;00m"

# load git completion
# to get script run : sudo curl -o /etc/bash_completion.d/git-completion https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
source /etc/bash_completion.d/git-completion

# load git prompt
# to get script run : sudo curl -o /etc/bash_completion.d/git-prompt https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source /etc/bash_completion.d/git-prompt

# git prompt env variables
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_DESCRIBE_STYLE='contains'
GIT_PS1_SHOWCOLORHINTS='y'
GIT_PS1_SHOWDIRTYSTATE='y'
GIT_PS1_SHOWSTASHSTATE='y'
GIT_PS1_SHOWUNTRACKEDFILES='y'
GIT_PS1_SHOWUPSTREAM='auto'

# this function test's if an error occured during the last function call, if so it colors the prompt red and prints the error_code
function error_test {
    return_code=$?
    if [[ $return_code -ne 0 ]]; then
        echo -e "$LIGHTRED[$return_code] "
    else
        echo -e "$LIGHTGREEN"
    fi
}

# define the prompt
PS1="\[\$(error_test)\]\u@\h : \W \[\$(__git_ps1 '$LIGHTYELLOW(%s) ')\]$RESET\$ "

##
# COLORS FOR 'ls' AND 'grep'
##

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

##
# ALIASE
##

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
