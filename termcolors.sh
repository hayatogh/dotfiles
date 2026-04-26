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
# RGB takes one of 00 5f 87 af d7 ff

# 39 default background
# 49 default foreground

colors_and_formattings()
{
	local clbg clfg attr
	for clbg in {40..47} {100..107} 49; do
		for clfg in {30..37} {90..97} 39; do
			for attr in {0..5} 7 9; do
				printf "\e[$attr;$clfg;${clbg}m ^[$attr;$clfg;${clbg}m \e[0m"
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
			if ((($color + 1) % 6 == 4)); then
				printf '\n'
			fi
		done
		printf '\n'
	done
}

color()
{
	local colors=(
		  0   1   3   2   6   4   5 n
		 15   9  11  10  14  12  13 n
		n
		224 _ _ _ _ _ _ _ _ 230 _ _ _ _ _ _ _ _ 194 _ _ _ _ _ _ _ _ 195 _ _ _ _ _ _ _ _ 189 _ _ _ _ _ _ _ _ 225 _ _ _ _ _ _ _ _ n
		217 _ _ _ 223 _ _ _ 229 _ _ _ 193 _ _ _ 157 _ _ _ 158 _ _ _ 159 _ _ _ 153 _ _ _ 147 _ _ _ 183 _ _ _ 219 _ _ _ 218 _ _ _ n
		210 _ _ 216 222 _ _ 228 _ _ 192 156 _ _ 120 _ _ 121 122 _ _ 123 _ _ 117 111 _ _ 105 _ _ 141 177 _ _ 213 _ _ 212 211 _ _ n
		203 _ 209 215 221 _ 227 _ 191 155 119 _  83 _  84  85  86 _  87 _  81  75  69 _  63 _  99 135 171 _ 207 _ 206 205 204 _ n
		196 202 208 214 220 226 190 154 118  82  46  47  48  49  50  51  45  39  33  27  21  57  93 129 165 201 200 199 198 197 n
		160 _ 166 172 178 _ 184 _ 148 112  76 _  40 _  41  42  43 _  44 _  38  32  26 _  20 _  56  92 128 _ 164 _ 163 162 161 _ n
		124 _ _ 130 136 _ _ 142 _ _ 106  70 _ _  34 _ _  35  36 _ _  37 _ _  31  25 _ _  19 _ _  55  91 _ _ 127 _ _ 126 125 _ _ n
		 88 _ _ _  94 _ _ _ 100 _ _ _  64 _ _ _  28 _ _ _  29 _ _ _  30 _ _ _  24 _ _ _  18 _ _ _  54 _ _ _  90 _ _ _  89 _ _ _ n
		 52 _ _ _ _ _ _ _ _  58 _ _ _ _ _ _ _ _  22 _ _ _ _ _ _ _ _  23 _ _ _ _ _ _ _ _  17 _ _ _ _ _ _ _ _  53 _ _ _ _ _ _ _ _ n
		n
		181 _ _ _ _ 187 _ _ _ _ 151 _ _ _ _ 152 _ _ _ _ 146 _ _ _ _ 182 _ _ _ _ n
		174 _ 180 _ 186 _ 150 _ 114 _ 115 _ 116 _ 110 _ 104 _ 140 _ 176 _ 175 _ n
		167 173 179 185 149 113  77  78  79  80  74  68  62  98 134 170 169 168 n
		131 _ 137 _ 143 _ 107 _  71 _  72 _  73 _  67 _  61 _  97 _ 133 _ 132 _ n
		 95 _ _ _ _ 101 _ _ _ _  65 _ _ _ _  66 _ _ _ _  60 _ _ _ _  96 _ _ _ _ n
		n
		138 144 108 109 103 139 n
		n
		 16 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _  59 _ _ _ _ _ _ 102 _ _ _ _ _ _ 145 _ _ _ _ _ _ 188 _ _ _ _ 231 n
		_ 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 n
	)
	local rev
	for rev in "" "7;"; do
		for color in "${colors[@]}"; do
			if [[ $color == n ]]; then
				printf '\n'
			elif [[ $color == _ ]]; then
				printf '  '
			else
				printf "\e[${rev}38;5;${color}m%3s \e[0m" $color
			fi
		done
		printf '\n'
	done
}

if [[ $0 == ${BASH_SOURCE[0]} ]]; then
	if [[ ${1:-} == format ]]; then
		colors_and_formattings
	elif [[ ${1:-} == 256 ]]; then
		colors256
	else
		color
	fi
fi
