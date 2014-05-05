#!/bin/bash
installFile(){
    if [ -L ~/$1 -o -f ~/.olddotfiles/$1 -o -d ~/.olddotfiles/$1 ]; then
        echo A link to $1 already exists.  Something is wrong.
    else
        mv ~/$1 ~/.olddotfiles/$1
        ln -s ~/.dotfiles/$1 ~/$1
    fi
}

if [ -d ~/.olddotfiles ]
    then
        echo "There is an older version of backedup dot files.  Please run the uninstall before you install again."
    else
        mkdir ~/.olddotfiles
        installFile .vim
        installFile .bashrc
        installFile .bash_profile
        installFile .bash_aliases
        installFile .vimrc
        installFile .pythonrc
fi
