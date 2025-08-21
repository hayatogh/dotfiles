#!/bin/bash
set -euo pipefail

dotfiles=$(cd $(dirname $0); pwd -P)

if sudo true; then
	addsudo='sudo sh'
else
	addsudo=su
	echo -n '[su] '
fi
$addsudo -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
sudo sh -c 'echo "Defaults !admin_flag" >/etc/sudoers.d/disable_admin_file_in_home'
rm -f ~/.sudo_as_admin_successful

if [[ $(ps -p 1 -o comm=) == systemd ]]; then
	sudo timedatectl set-timezone Asia/Tokyo
fi

for f in /etc/apt/sources.list /etc/apt/sources.list.d/debian.sources; do
	if [[ -e $f ]]; then
		sudo sed -Ei 's/main( non-free-firmware)?$/& non-free/' $f
	fi
done

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install 7zip automake bash-completion bc bison chezscheme clang-format clangd command-not-found curl fd-find flex gcc gdb git-delta gnutls-dev htop info lftp libelf-dev libc-dev libncurses-dev libpam-dev libpng-dev libssl-dev libtool lshw lsof make man-db moreutils nasm perl-doc pkg-config pmount ripgrep rlwrap rsync texinfo tree uchardet universal-ctags vim wget wl-clipboard xfsprogs zip \
	python3-venv yapf3 python3-pylsp python3-pylsp-isort python3-pylsp-mypy \
	gdb-doc

sudo mkdir -p /usr/local/bin
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
sudo ln -sf /usr/bin/yapf3 /usr/local/bin/yapf
