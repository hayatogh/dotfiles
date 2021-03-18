#!/usr/bin/env bash
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install gcc make libc6-dev gdb automake pkg-config
sudo apt-get -y install wget vim universal-ctags fd-find screen lshw curl uchardet nkf bash-completion rlwrap info zip
sudo apt-get -y install python3-pip chezscheme
# sudo apt-get -y install ripgrep
## kernel
# sudo apt-get -y install linux-headers-`uname -r`
sudo apt-get -y install libncurses-dev flex bison libssl-dev bc libelf-dev
## syzkaller
# sudo apt-get install -y debootstrap qemu-system-x86

ln -sf /usr/bin/fdfind ~/.local/bin/fd

# manual install
dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
cd $dotfiles
./dpkg-install.sh

./install-which.sh
./install-vim.sh
./install-cheat.sh

./getbashcompletion.sh
