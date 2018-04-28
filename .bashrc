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

if [ -f ~/.work_aliases ]; then
    . ~/.work_aliases
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
PERSONAL_BIN=~/.bin:~/bin
NODE_FOR_OSX=/usr/local/share/npm/bin
DUNNO=~/.dotfiles/custom-scripts/0.1.0_darwin_amd64
AWS_STUFF=~/.dotfiles/custom-scripts/aws/eb/macosx/python2.7
CABAL=$HOME/Library/Haskell/bin

export PATH=$PERSONAL_BIN:$CABAL:$BREW_STUFF:$AWS_STUFF:$CUSTOM_SCRIPTS:$DUNNO:$NODE_FOR_OSX:$PATH

#android path things for fennec
export PATH=$PATH:$HOME/android/adt-bundle-mac-x86_64-20130729/sdk/tools:$HOME/android/adt-bundle-mac-x86_64-20130729/sdk/build-tools:$HOME/android/adt-bundle-mac-x86_64-20130729ac/sdk/platform-tools

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
# rust stuff

export RUST_SRC_PATH=$HOME/dev/foss/rust/rust/src

# host and current directory
# PS1='\h:\W \$ '
# host and current directory, with some color fiddling
# PS1='\[\033[01;30;47m\]\h\[\033[00m\]:\[\033[00;31m\]\W\[\033[00m\]\$ '
# playing with colors in general, so want to remove as much lower-level customization while i find something that works.
# -- the $? will give you the return code of the last command
# PS1='- - -\n\W $?\n 🍔  ~> '
# PS1='- - -\n\W $?\n 🍔  - ❯❯❯ '
PS1='- - -\n\W $?\n- ❯❯❯ '
export LSCOLORS=gxfxcxdxbxegedabagacad
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


# prevent global python from getting accidentally messed up
export PIP_REQUIRE_VIRTUALENV=true

# virtualenvwrapper stuff
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev
# init virtualenvwrapper on mac

if [ `whoami` = 'cdean' ]; then
    # homebrew broke how python works so i have to redo some tooling
    if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        # use lazy loader for virtualenv
        # http://virtualenvwrapper.readthedocs.io/en/latest/install.html#lazy-loading
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
        export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
        source /usr/local/bin/virtualenvwrapper_lazy.sh
    fi
else
    # other computers do other things i guess
    if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
        # use lazy loader for virtualenv
        # http://virtualenvwrapper.readthedocs.io/en/latest/install.html#lazy-loading
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
        export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
        source /usr/local/bin/virtualenvwrapper_lazy.sh
    fi
fi

## some db things
if [ -f /Users/cdean/dw_db_inits ]; then
    .  /Users/cdean/dw_db_inits
fi

eval `opam config env`

# ive ruined this
#export PATH="/Users/cdean/.pyenv/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

if [ -f $HOME/work_ansible_settings ]; then
    . $HOME/work_ansible_settings
fi

if [ -f $HOME/more_work_stuff ]; then
    . $HOME/more_work_stuff
fi

# notify
# usage: 'quack the build is finished'
quack(){
    EAT_IT=$@ osascript -e 'display notification (system attribute "EAT_IT") with title "THE TERMINAL IS NEEDY AGAIN"'
}

# for great 'gres
PGAPP_BIN_DIR=/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH=$PGAPP_BIN_DIR:$PATH

# brew install fasd
# thx @lepht
eval "$(fasd --init auto)"
# and an alias for it
alias v='fasd -e vim -f'

# activate fzf hooks
# from `brew install fzf`
# `/usr/local/opt/fzf/install`
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# change how fzf gets sourced files
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ `whoami` = 'cdean' ]; then
    # on worklaptop
    # intalling maek through brew results in this dumb shit of having all make tools
    # prefixed with a 'g'. gmake instead of make.
    # turns out when you change the name of a command, all build scripts of open source projects
    # do not work.

    # have to explicitly add all these things
    # from their install notice:
    #
    # If you need to use these commands with their normal names, you
    # can add a "gnubin" directory to your PATH from your bashrc like:
    PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
    # Additionally, you can access their man pages with normal names if you add
    # the "gnuman" directory to your MANPATH from your bashrc as well:
    MANPATH="/usr/local/opt/make/libexec/gnuman:$MANPATH"
    # something about airflow
    export AIRFLOW_HOME=/Users/cdean/dev/work/airflow
fi
