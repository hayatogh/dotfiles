#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
sudo sh -c 'echo "Defaults !admin_flag" >/etc/sudoers.d/disable_admin_file_in_home'
rm -f ~/.sudo_as_admin_successful

if [[ $(ps -p 1 -o comm=) == systemd ]]; then
	sudo timedatectl set-timezone Asia/Tokyo
fi

sudo sed -i 's/main$/& non-free/' /etc/apt/sources.list

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install 7zip automake bash-completion bc chezscheme clang-format clangd command-not-found curl fd-find gcc gdb gnutls-dev htop info lftp libc-dev libncurses-dev lshw lsof make man-db moreutils perl-doc pkg-config pmount ripgrep rlwrap rsync screen texinfo tree uchardet universal-ctags vim wget wl-clipboard xfsprogs zip \
	python3-venv yapf3 python3-pylsp python3-pylsp-isort python3-pylsp-mypy \
	gdb-doc
## kernel
# libncurses-dev flex bison libssl-dev bc libelf-dev rsync linux-headers-`uname -r`

sudo mkdir -p /usr/local/bin
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
sudo ln -sf /usr/bin/yapf3 /usr/local/bin/yapf

sudo $dotfiles/install-delta.sh

$dotfiles/getbashcompletion.sh pip3
