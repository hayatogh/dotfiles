#!/usr/bin/env bash
sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"

dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
apt-get update
apt-get -y upgrade
apt-get -y install gcc make libc6-dev gdb automake pkg-config
apt-get -y install wget vim universal-ctags ripgrep fd-find screen lshw curl uchardet nkf bash-completion rlwrap info zip
apt-get -y install python3-pip chezscheme
## kernel
# apt-get -y install linux-headers-`uname -r`
apt-get -y install libncurses-dev flex bison libssl-dev bc libelf-dev
## syzkaller
# apt-get install -y debootstrap qemu-system-x86

# manual install
cd $dotfiles
./dpkg-install.sh

./install-which.sh
./install-vim.sh
./install-screen.sh
./install-cheat.sh

./getbashcompletion.sh
