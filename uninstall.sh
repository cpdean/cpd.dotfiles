#!/bin/bash

if [ -d ~/.olddotfiles ]
    then
        cp -rf ~/.olddotfiles/* ~/
        rm -rf ~/.olddotfiles
    else
        echo "You don't have a folder of old dotfiles."
        echo "No way to uninstall."
fi
