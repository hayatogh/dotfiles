#!/usr/bin/env bash
set -euo pipefail

pacman -Syu --noconfirm
pacman -S --needed --noconfirm man-db mingw-w64-x86_64-uchardet
# base base-devel gettext-devel libcrypt-devel mingw-w64-x86_64-toolchain msys2-devel ncurses-devel
# cp -f /usr/bin/windres.exe /usr/bin/x86_64-pc-msys-windres.exe
