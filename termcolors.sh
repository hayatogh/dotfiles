#!/bin/bash
# \e[Xm
# can be combined as many you want with separator ';'

# 0 Reset all

# 1        Bold/Bright
# 2        Dim
# 3        Italic
# 4        Underlined
# 5        Blink
# 7        Reverse
# 8        Hidden
# 9        Strikeout
# 2X Reset

# X = 0-7
#     0 Black  1 Red      2 Green  3 Yellow
#     4 Blue   5 Magenta  6 Cyan   7 Light gray
# 3X foreground  9X bright fore
# 4X background 10X bright back

# 38;5;0-255 256color fore
# 48;5;0-255 256color back

# 39 default background
# 49 default foreground

colors_and_formattings()
{
	local clbg clfg attr
	for clbg in {40..47} {100..107} 49; do
		for clfg in {30..37} {90..97} 39; do
			for attr in 0 1 2 3 4 5 7 9; do
				printf "\e[$attr;$clbg;${clfg}m ^[$attr;$clbg;${clfg}m \e[0m"
			done
			printf '\n'
		done
	done
}

colors256()
{
	local fgbg color
	for fgbg in 38 48; do
		for color in {0..255}; do
			printf "\e[$fgbg;5;${color}m  %3s  \e[0m" $color
			if [[ $((($color + 1) % 6)) -eq 4 ]]; then
				printf '\n'
			fi
		done
		printf '\n'
	done
}

if [[ $0 == ${BASH_SOURCE[0]} ]]; then
	if [[ ${1:-} == format ]]; then
		colors_and_formattings
	else
		colors256
	fi
fi
