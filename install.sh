#!/bin/bash
#change to home directory and clone repo
cd ~
git clone https://jayanthram_kv@bitbucket.org/jayanthram_kv/dotvim.git ~/.vim

# add symlinks
ln -s ~/.vim/vimrc ~/.vimrc

# change to .vim folder, init and update the submodules
cd ~/.vim
git submodule init
git submodule update

#Upgrading all submodules
git submodule foreach git pull origin master