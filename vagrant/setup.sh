#!/usr/bin/env bash
# sudo su -
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install git
rm -rf ~/dotfiles
git clone --depth 1 -- git://github.com/matsuhav/dotfiles ~/dotfiles
sudo ~/dotfiles/apt-get-install.sh
~/dotfiles/lndots.sh
if [[ $USER == root ]]; then
	echo 'sudo su -' > ~vagrant/.profile
fi
