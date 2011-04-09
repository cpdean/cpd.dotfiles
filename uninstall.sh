#!/bin/bash

replaceLink(){
# Assumption is that existence of .olddotfiles means deleting the link
# won't delete anything important.
    if [ -L ~/$1 ]
        then
        if [ -d ~/.olddotfiles/$1 -o -f ~/.olddotfiles/$1 ]; then
            rm ~/$1
            cp -rf ~/.olddotfiles/$1 ~/
        else
            echo $1 not found in ~/.dotfiles, so we
            echo will not be replacing that.
        fi
        else
            echo $1 link not found in ~/
    fi
}

if [ -d ~/.olddotfiles ]
    then
        replaceLink .bashrc
        replaceLink .bash_profile
        replaceLink .vimrc
        replaceLink .vim

        echo "Finished transfering backed up dot files."
        echo "Check to make sure that the contents of"
        echo "~/.olddotfiles matches the contents of ~/"
        echo "and run rm -rf ~/.olddotfiles to finish uninstall"
    else
        echo "You don't have a folder of old dotfiles."
        echo "No way to uninstall."
fi
