#!/usr/bin/env bash
set -euo pipefail

pacman -Syu --noconfirm
# pacman -S --needed --noconfirm base
# pacman -S --needed --noconfirm base-devel
# pacman -S --needed --noconfirm msys2-devel
# pacman -S --needed --noconfirm gettext-devel
# pacman -S --needed --noconfirm libcrypt-devel
# pacman -S --needed --noconfirm ncurses-devel
# pacman -S --needed --noconfirm mingw-w64-x86_64-toolchain
pacman -S --needed --noconfirm fzy
pacman -S --needed --noconfirm mingw-w64-x86_64-uchardet
pacman -S --needed --noconfirm man-db
# cp -f /usr/bin/windres.exe /usr/bin/x86_64-pc-msys-windres.exe
