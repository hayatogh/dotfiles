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
	"gh:imsnif/kdl.vim"
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
		timeout 10 git -C $dir fetch --depth 1 &>/dev/null \
			&& git -C $dir reset --hard &>/dev/null
		ret=$?
	else
		echo "Clone $plug" >&2
		url=$(to_url $plug)
		timeout 10 git clone --depth 1 -- $url $dir &>/dev/null
		ret=$?
	fi
	if [[ $ret -eq 0 ]]; then
		echo " Done $plug" >&2
	else
		echo " Error($ret) $plug" >&2
	fi
}
update_all() {
	local p

	for p in "${plugs[@]:0:$njobs}"; do
		update $p &
	done
	for p in "${plugs[@]:$njobs:${#plugs[@]}-$njobs}"; do
		wait -n
		update $p &
	done
	wait
}
clean() {
	local installed= p dir
	for p in ${plugs[@]}; do
		p=${p##*/}
		p=${p//./\\.}
		installed=$installed$p'|'
	done
	installed=${installed%|}

	for dir in $dest/*; do
		dir=${dir##*/}
		if [[ ! $dir =~ $installed ]]; then
			rm -rf $dir
		fi
	done
}
helptags() {
	vim -i NONE --not-a-term '+helptags ALL' '+q' >/dev/null
}

main() {
	shopt -s nullglob
	mkdir -p $dest
	update_all
	clean
	helptags
}

main
