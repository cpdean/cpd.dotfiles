#!/bin/bash
if [ -d ~/.olddotfiles ]
    then
        #Don't know how to do this cleanly
        cp ~/.olddotfiles/.bashrc ~/
        cp ~/.olddotfiles/.bash_profile ~/
        cp ~/.olddotfiles/.vimrc ~/
        cp ~/.olddotfiles/.vim ~/

        echo "Finished transfering backed up dot files."
        echo "Check to make sure that the contents of"
        echo "~/.olddotfiles matches the contents of ~/"
        echo "and run rm -rf ~/.olddotfiles to finish uninstall"
    else
        echo "You don't have a folder of old dotfiles."
        echo "No way to uninstall."
fi
