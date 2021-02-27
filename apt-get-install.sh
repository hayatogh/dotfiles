#!/usr/bin/env bash
sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"

dotfiles=$(realpath $(dirname ${BASH_SOURCE[0]}))
apt-get update
apt-get -y upgrade
apt-get -y install wget vim gcc make libc6-dev gdb qemu automake pkg-config
apt-get -y install universal-ctags ripgrep fd-find screen python3-pip
apt-get -y install lshw curl uchardet nkf bash-completion rlwrap chezscheme
# apt-get -y install unzip libcap-dev
## linux kernel
# apt-get -y install linux-headers-`uname -r`
apt-get -y install libncurses-dev flex bison libssl-dev bc libelf-dev
# apt-get install -y ncurses-doc flex-doc libssl-doc
## xv6
# apt-get install -y git gcc make gdb qemu
# git clone git://github.com/mit-pdos/xv6-public.git $HOME/xv6-public
# echo "add-auto-load-safe-path $HOME/xv6-public/.gdbinit" > $HOME/.gdbinit
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
