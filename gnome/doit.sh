#!/usr/bin/env bash
set -euo pipefail

gnome=$(cd $(dirname $0); pwd -P)

dconf load /org/gnome/ < $gnome/org.gnome.dump
if dconf dump /org/gnome/terminal &>/dev/null; then
	profile=$(dconf dump /org/gnome/terminal/legacy/profiles:/ | head -n1)
	printf "${profile}\n$(cat $gnome/org.gnome.terminal.legacy.profiles.profile)\n" | dconf load /org/gnome/terminal/legacy/profiles:/
else
	echo 'Gnome terminal profile id not found'
	echo 'Change profile setting and run again'
fi

mkdir -p ~/.config/autostart
cp /usr/share/applications/org.gnome.Terminal.desktop ~/.config/autostart
