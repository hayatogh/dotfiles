#!/bin/bash
set -euo pipefail

pacman -Syu --noconfirm
pacman -S --needed --noconfirm man-db
# mingw-w64-x86_64-uchardet
# cp -f /usr/bin/windres.exe /usr/bin/x86_64-pc-msys-windres.exe
