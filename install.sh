#!/bin/bash
if [ -d ~/.olddotfiles ]
    then
        echo "There is an older version of backedup dot files.  Please run the uninstall before you install again."
    else
        mkdir ~/.olddotfiles

        mv ~/.vim ~/.olddotfiles/.vim
        ln -s ~/.dotfiles/.vim ~/.vim

        mv ~/.bashrc ~/.olddotfiles/.bashrc
        ln -s ~/.dotfiles/.bashrc ~/.bashrc

        mv ~/.bash_profile ~/.olddotfiles/.bash_profile
        ln -s ~/.dotfiles/.bash_profile ~/.bash_profile

        mv ~/.vimrc ~/.olddotfiles/.vimrc
        ln -s ~/.dotfiles/.vimrc ~/.vimrc
fi
