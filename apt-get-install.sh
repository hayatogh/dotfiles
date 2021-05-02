#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
sudo timedatectl set-timezone Asia/Tokyo

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install automake bash-completion bc curl fd-find gcc gdb htop info libc6-dev libncurses-dev lshw lsof make nkf pkg-config pmount rlwrap rsync screen uchardet universal-ctags vim wget zip
sudo apt-get -y install python3-pip chezscheme
# sudo apt-get -y install ripgrep
## kernel
# sudo apt-get -y install linux-headers-`uname -r`
sudo apt-get -y install libncurses-dev flex bison libssl-dev bc libelf-dev rsync
## syzkaller
# sudo apt-get install -y debootstrap qemu-system-x86

ln -sf /usr/bin/fdfind ~/.local/bin/fd

# manual install
cd $dotfiles
./install-rg.sh

./install-vim.sh
./install-cheat.sh

./getbashcompletion.sh
