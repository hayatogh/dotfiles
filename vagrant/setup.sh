#!/usr/bin/env bash
set -euo pipefail

# sudo su -
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install git
rm -rf ~/dotfiles
git clone --depth 1 -- https://github.com/hayatogh/dotfiles ~/dotfiles
~/dotfiles/apt-get-install.sh
~/dotfiles/lndots.sh
if [[ $USER == root ]]; then
	echo 'sudo su -' > ~vagrant/.profile
fi
