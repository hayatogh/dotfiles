#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
if [[ $(ps -p 1 -o comm=) == systemd ]]; then
	sudo timedatectl set-timezone Asia/Tokyo
fi

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install aha automake bash-completion bc clang-format clangd command-not-found curl fd-find gcc gdb global gnutls-dev htop info lftp libc-dev libncurses-dev lshw lsof make man-db moreutils nkf pkg-config pmount ripgrep rlwrap rsync screen texinfo tree uchardet universal-ctags vim wget xfsprogs zip
sudo apt-get -y install python3-pip chezscheme
sudo apt-get -y install gdb-doc
## kernel
# libncurses-dev flex bison libssl-dev bc libelf-dev rsync linux-headers-`uname -r`
## syzkaller
# debootstrap qemu-system-x86

mkdir -p ~/.local/bin
ln -sf /usr/bin/fdfind ~/.local/bin/fd

$dotfiles/getbashcompletion.sh pip3
