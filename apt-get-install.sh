#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
if [[ $(ps -p 1 -o comm=) == systemd ]]; then
	sudo timedatectl set-timezone Asia/Tokyo
fi

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install automake bash-completion bc command-not-found curl fd-find gcc gdb htop info libc6-dev libncurses-dev lshw lsof make man nkf pkg-config pmount ripgrep rlwrap rsync screen tree uchardet universal-ctags vim wget zip
sudo apt-get -y install python3-pip chezscheme
## kernel
# libncurses-dev flex bison libssl-dev bc libelf-dev rsync linux-headers-`uname -r`
## syzkaller
# debootstrap qemu-system-x86

mkdir -p ~/.local/bin
ln -sf /usr/bin/fdfind ~/.local/bin/fd

cd $dotfiles
./install-cheat.sh

./getbashcompletion.sh pip3
