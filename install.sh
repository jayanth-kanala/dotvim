#!/bin/bash

# check if git is installed
if [ ! "$type $git" >  /dev/null ]; then
  # install foobar here
  sudo apt-get install git
else 
	echo "git is installed"
fi

if [ ! "$type $vim" > /dev/null ]; then
	sudo apt-get install vim-gnome
else
	echo "vim is installed."
fi

#change to home directory and clone repo
cd ~
#clone the .vim repo
git clone https://jayanthram_kv@bitbucket.org/jayanthram_kv/dotvim.git ~/.vim

# add symlinks
ln -s ~/.vim/vimrc ~/.vimrc

# change to .vim folder, init and update the submodules
cd ~/.vim
git submodule init
git submodule update

#Upgrading all submodules
git submodule foreach git pull origin master