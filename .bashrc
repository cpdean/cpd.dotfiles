# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
complete -C aws_completer aws

BREW_STUFF=/usr/local/bin
CUSTOM_SCRIPTS=~/.dotfiles/custom-scripts
PERSONAL_BIN=~/.bin
NODE_FOR_OSX=/usr/local/share/npm/bin
DUNNO=~/.dotfiles/custom-scripts/0.1.0_darwin_amd64
AWS_STUFF=~/.dotfiles/custom-scripts/aws/eb/macosx/python2.7
CABAL=$HOME/Library/Haskell/bin

export PATH=$PERSONAL_BIN:$CABAL:$BREW_STUFF:$AWS_STUFF:$CUSTOM_SCRIPTS:$DUNNO:$NODE_FOR_OSX:$PATH

#android path things for fennec
export PATH=$PATH:$HOME/android/adt-bundle-mac-x86_64-20130729/sdk/tools:$HOME/android/adt-bundle-mac-x86_64-20130729/sdk/build-tools:$HOME/android/adt-bundle-mac-x86_64-20130729ac/sdk/platform-tools

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

#PS1='\h:\W \u\$ '
PS1='\h:\e[0;31m\W \e[0;32m\$\[\e[0m\] ' # Why is this guy broken?
PS1='\h:\W \$ '
PS1='\[\033[01;30;47m\]\h\[\033[00m\]:\[\033[00;31m\]\W\[\033[00m\]\$ '
EDITOR=vim

# set ls to use colors
export CLICOLOR=1 

# hook into git compeletion for bash
if [ -f ~/.dotfiles/.git-completion.bash ]; then
    . ~/.dotfiles/.git-completion.bash
fi

# fix colors in tmux
alias tmux="TERM=screen-256color-bce tmux"

# tab completion for python, and maybe other stuff
export PYTHONSTARTUP=~/.pythonrc

# virtualenvwrapper stuff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev
# init virtualenvwrapper on mac
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
    source /usr/local/bin/virtualenvwrapper.sh
fi
