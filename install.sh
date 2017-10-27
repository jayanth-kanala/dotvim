#!/bin/bash

# check if git is installed
if type git 2>/dev/null >/dev/null; then
	echo "Git installed"
else
	echo "Git not installed"
fi
if type vim 2>/dev/null >/dev/null; then
	echo "Vim installed"
else
	echo "Vim not installed"
fi

#change to home directory and clone repo
cd ~
#clone the .vim repo
git clone git@github.com:jayanthramkv/dotvim.git ~/.vim

# add symlinks
ln -s ~/.vim/vimrc ~/.vimrc

# change to .vim folder, init and update the submodules
cd ~/.vim
git submodule init
git submodule update

#Upgrading all submodules
git submodule foreach git pull origin master
