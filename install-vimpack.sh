#!/usr/bin/bash

dest=~/.vim/pack/remote/start
njobs=4
plugs=(
	"gh:tpope/vim-commentary"
	"gh:editorconfig/editorconfig-vim"
	"gh:mattn/emmet-vim"
	"gh:tpope/vim-eunuch"
	"gh:tommcdo/vim-lion"
	"gh:preservim/nerdtree"
	"gh:luochen1990/rainbow"
	"gh:hayatogh/vim-surround"
	# "gh:guns/xterm-color-table.vim"
	# external commands
	"gh:dense-analysis/ale"
	"gh:HiPhish/info.vim"
	"gh:thinca/vim-quickrun"
	# libraries
	"gh:kana/vim-operator-user"
	"gh:kana/vim-textobj-indent"
	"gh:kana/vim-textobj-user"
	"gh:hayatogh/vim-bash-completion"
	"gh:tyru/open-browser.vim"
	# colorscheme
	# "gh:lifepillar/vim-colortemplate"
	"gh:tomasr/molokai"
	# syntax and filetype plugins
	"gh:chrisbra/csv.vim"
	"gh:HealsCodes/vim-gas"
	"gh:previm/previm"
	# "gh:kchmck/vim-coffee-script"
	# "gh:lervag/vimtex"
)

to_url() {
	sed 's;^gh:;https://github.com/;' <<<$1
}
to_dir() {
	echo $dest/${1##*/}
}
update() {
	local plug=$1 url dir ret
	dir=$(to_dir $plug)

	if [[ -d $dir ]]; then
		echo "Fetch $plug" >&2
		git -C $dir fetch --depth 1 &>/dev/null \
			&& git -C $dir reset --hard &>/dev/null
		ret=$?
	else
		echo "Clone $plug" >&2
		url=$(to_url $plug)
		git clone --depth 1 -- $url $dir &>/dev/null
		ret=$?
	fi
	if [[ $ret -eq 0 ]]; then
		echo " Done $plug" >&2
	else
		echo " Error $plug" >&2
	fi
}
update_all() {
	local p
	for p in "${plugs[@]:0:${#plugs[@]}-1}"; do
		update $p
	done

	# for p in "${plugs[@]:0:$njobs-1}"; do
	# 	update $p &
	# done
	# for p in "${plugs[@]:$njobs:${#plugs[@]}-1}"; do
	# 	wait -n < <(jobs -p)
	# 	update $p &
	# done
	# wait
}
clean() {
	local installed p dir base
	p=${plugs[@]:0:1}
	installed=${p##*/}
	for p in "${plugs[@]:1:${#plugs[@]}-1}"; do
		installed=$installed'|'${p##*/}
	done

	for dir in $dest/*; do
		base=${dir##*/}
		if [[ ! $base =~ $installed ]]; then
			rm -rf $dir
		fi
	done
}

main() {
	mkdir -p $dest
	update_all
	clean
}

main
