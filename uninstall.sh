#!/bin/bash

if [ -d ~/.olddotfiles ]
    then
        #Don't know how to do this cleanly
        mv ~/.olddotfiles/.bashrc ~/
        mv ~/.olddotfiles/.vimrc ~/

        rm ~/.vim
        mv ~/.olddotfiles/.vim ~/
        rm -rf ~/.olddotfiles
    else
        echo "You don't have a folder of old dotfiles."
        echo "No way to uninstall."
fi
