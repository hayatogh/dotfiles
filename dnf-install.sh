#!/usr/bin/env bash
dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
dnf -y upgrade
dnf -y remove PackageKit-command-not-found
dnf -y install vim-X11 make automake
dnf -y install ripgrep fd-find screen
dnf -y install ed indent wdiff patch p7zip texinfo w3m
dnf -y install powertop kernel-tools lshw gnome-tweaks onedrive
## linux kernel
dnf -y install ncurses-devel flex bison elfutils-libelf-devel openssl-devel

systemctl enable iwd
for ex in ex exim vim view vimdiff; do
	ln -sf /usr/bin/gvim /usr/bin/$ex
done

# manual install
cd $dotfiles
./install-universal-ctags.sh
./pip3-install.sh
