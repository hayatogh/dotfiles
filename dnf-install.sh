#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
sudo dnf -y upgrade
sudo dnf -y remove PackageKit-command-not-found
sudo dnf -y install vim-X11 make automake
sudo dnf -y install ripgrep fd-find screen
sudo dnf -y install ed indent wdiff patch p7zip texinfo w3m
sudo dnf -y install powertop kernel-tools lshw gnome-tweaks onedrive
## linux kernel
sudo dnf -y install ncurses-devel flex bison elfutils-libelf-devel openssl-devel

sudo systemctl enable iwd
for ex in ex exim vim view vimdiff; do
	sudo ln -sf /usr/bin/gvim /usr/bin/$ex
done

# manual install
cd $dotfiles
./install-universal-ctags.sh
./pip3-install.sh
