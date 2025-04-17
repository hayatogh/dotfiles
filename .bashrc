[[ ! $- =~ i ]] && return
shopt -s autocd cdspell checkhash checkjobs checkwinsize dotglob execfail globstar lithist no_empty_cmd_completion nocaseglob

_pc0='history -a; history -c; history -r'
_pc1='\[\e]0;\u@\h \w \d \A [\j] \a\]'
_pc2='\[\e[0m\]\n'
_pc3='$PSM\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[38;5;93m\]$PSSHLVL \[\e[38;5;166m\]$([[ \j -gt 0 ]] && echo \j)\[\e[0m\]'
_pc4=' \[\e[38;5;245m\]\t ${PIPESTATUS[@]}\[\e[0m\]\n\[\ek\e\\\]\$ '
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='pwd:bash:sr:vim:ls:la:ll:al:cd:cd -:cd ..:cd ../..:git s:git ss:git d:git dc:git dw:git ds:git dn:git dt:git g:git l:upgrade:sush'
HISTSIZE=2000
HISTTIMEFORMAT='%c : '
if [[ ${SUDO_USER:-} ]]; then
	HISTFILE=~/.root_history
fi

PSSHLVL=
if [[ $TERM =~ screen ]]; then
	if [[ $SHLVL > 2 ]]; then
		PSSHLVL=$(($SHLVL - 1))
	fi
elif [[ $SHLVL > 1 ]]; then
	PSSHLVL=$SHLVL
fi
PSM=${PSM:-}
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp -p'
alias dus='du -chs'
alias diff='diff --color=auto'
alias diffr='git diff --no-index --histogram'
alias diffl='diffr -U2147483647'
alias diffc='diffl --word-diff-regex=.'
alias diffw='diffl --word-diff-regex='\''\S+|[^\S]'\'''
alias ee=exit
alias fd='fd -HE.git/'
alias fdall='fd -I'
alias git_dotfiles_pull='git -C ~/dotfiles pull'
alias git_empty_commit='git add -A && git commit -m '\''No commit message'\'' && git push'
alias grep='grep --color=auto'
alias info='info --init-file '$HOME'/dotfiles/infokey'
alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -lhF'
alias al='ls -alhF'
alias lls='ls -alhFs'
alias ltime='ls -alhrtF'
alias lsize='ls -alhrFS'
alias manless='man -P less'
alias rm='rm -i'
alias sc='script -qc sh'
alias scheme='scheme '$HOME'/dotfiles/chezrc.ss'
alias sudo_proxy='sudo --preserve-env=https_proxy,http_proxy,ftp_proxy,no_proxy'
alias tm='tmux new -ADX'
alias vi='vim --clean'
alias which &>/dev/null && unalias which
sr() {
	if [[ ${STY:-} ]]; then
		screen
		return
	fi
	local tty=${SCREEN_TTY:-${SSH_TTY:-$(tty)}}
	screen -X setenv SCREEN_TTY $tty &>/dev/null
	SCREEN_TTY=$tty screen -DR
}
alias l. &>/dev/null && unalias l.
l.() {
	([[ $# != 0 ]] && cd "$1"; ls -dF .*)
}
tryssh() {
	local sleeptime=5
	[[ $# == 0 ]] && return 1
	[[ $# == 2 ]] && sleeptime=$2
	while printf .; do
		ssh $1 true &>/dev/null && printf '\n' && break
		sleep $sleeptime
	done
	ssh $1
}
mkcd() {
	mkdir "$1"
	cd "$1"
}
_regex_rubout() {
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ $1 ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_LINE=$left$right
	READLINE_POINT=${#left}
}
_cw() {
	_regex_rubout '([a-zA-Z0-9]+|[^ a-zA-Z0-9]+) *$'
}
bind -x '"\C-w": _cw'
bind -x '"\eh": _cw'
_mbackslash() {
	_regex_rubout '([^ ;&|<>] *)*(;|&&|\|\||\||\|&|<|>|<<|>>|&>|>&)? *$'
}
bind -x '"\e\\": _mbackslash'
stopwatch() {
	local c t acc=0 start=${EPOCHREALTIME/./} int=${1:-.1}
	[[ $int < 0.1 ]] && read -N1 -t.1 c
	while true; do
		read -N1 -t$int c
		t=$(($acc + ${EPOCHREALTIME/./} - $start))
		printf "\r${t:: -6}.${t: -6}"

		if [[ -z $c || $c == $'\n' ]]; then
			continue
		elif [[ $c == ' ' ]]; then
			printf '\n'
			acc=$t
			read -N1 c
			start=${EPOCHREALTIME/./}
			printf '\n'
		else
			break
		fi
	done
}
cdd() {
	cd "$(dirname "$1")"
}
mktags() {
	if [[ -f Kbuild ]]; then
		local arch=x86
		if [[ ${1:-} =~ arm ]]; then
			arch=arm64
		fi
		rm -f tags
		make SRCARCH=$arch tags &>/dev/null
		mv tags tags.$arch
		ln -s tags.$arch tags
	elif [[ ${#@} != 0 ]]; then
		ctags "$@" &>/dev/null
	else
		ctags -R &>/dev/null
	fi
}
realwhich() {
	realpath "$(which "$1")"
}
clean_history() {
	[[ $# == 1 ]] || return 1
	local pat=$1
	perl -0777 -i -pe 's/^#\d+\n('"$pat"') *\n//gm' $HISTFILE
}
fix_history() {
	perl -i -ne 'BEGIN { $sawtime = 0 } if (/^#/) { $sawtime = 1 } if ($sawtime) { print }' $HISTFILE
}
fixmod() {
	find "$@" -maxdepth 0 -type f -print0 | xargs -0 chmod 644
	find "$@" -maxdepth 0 -type d -print0 | xargs -0 chmod 755
}
rgall() {
	command rg --no-messages --hidden --no-ignore -g!tags -g!tags.x86 -g!tags.arm64 -g!.git/ "$@"
}
rg() {
	rgall --ignore -g!/po/*.po -g!/Documentation/translations "$@"
}
_rg_arch() {
	rg $(find arch/ -mindepth 1 -maxdepth 1 -type d -printf '-g!%f/ ' | sed -E 's:-g!('"$1"')/ ::') "${@:2}"
}
rgx() {
	_rg_arch x86 "$@"
}
rgarm() {
	_rg_arch 'arm|arm64' "$@"
}
vl() {
	vim $($1 -l "${@:2}")
}
_bc() {
	local in=$1 out=$2 opt exp=${@:3} ifilter=cat ofilter=cat
	if [[ $in == 10 && $out == 10 ]] && grep -Fq . <<<$exp; then
		opt=-l
	fi
	if [[ $in == 16 ]]; then
		ifilter='sed -E '\''s/\b(0[xX])?([0-9a-fA-F]+)/\U\2/g'\'
	fi
	if [[ $out == 16 ]]; then
		ofilter='sed -E '\''s/\b([0-9A-F]+)/\L\1/'\'
	fi
	bc $opt <<<"obase=$out; ibase=$in; $(eval $ifilter <<<$exp)" | eval $ofilter
}
bc10() {
	_bc 10 10 "$@"
}
bc16() {
	_bc 16 16 "$@"
}
to10() {
	_bc 16 10 "$@"
}
to16() {
	_bc 10 16 "$@"
}
calc() {
	local exp=$(sed -E 's/[kK]i?[bB]?/*(1<<10)/g;
s/[mM]i?[bB]?/*(1<<20)/g;
s/[gG]i?[bB]?/*(1<<30)/g;
s/[tT]i?[bB]?/*(1<<40)/g;
s/[pP]i?[bB]?/*(1<<50)/g' <<<"$*")
	perl -Mbignum -e '$x = ('"$exp"');
if ($x->is_int()) {
	$x = $x->as_int();
	$u64 = $x & 0xffffffffffffffff;
	$i64 = $u64 >> 63 ? -1 * (($u64 ^ 0xffffffffffffffff) + 1) : $u64;
	$u32 = $x & 0xffffffff;
	$i32 = $u32 >> 31 ? -1 * (($u32 ^ 0xffffffff) + 1) : $u32;
	if ($x->is_positive()) {
		$set = "";
		for (my $b = 0; $x >> $b; $b++) {
			if (($x >> $b) & 1) {
				$set = $b . " " . $set;
			}
		}
		$human = "";
		for (my @s = ("", "Ki", "Mi", "Gi", "Ti"), my $i = 0; $i < 5; $i++) {
			$human = ($x >> $i * 10) % 1024 . $s[$i] . " " . $human;
		}
		$human = ($x >> 50) . "Pi " . $human;
		$bytes = $x->to_bytes();
	} else {
		$set = "(NaN)";
		$human = "(NaN)";
		$bytes = "(NaN)";
	}
	printf "hex:      %s
decimal:  %s %s %s
octal:    %s
string:   %s
binary:   %s
bits set: %s
64 bit:   %#x %u %d
32 bit:   %#x %u %d
human:    %s
", $x->as_hex(), $x->bdstr(), $x->bnstr(), $x->bestr(), $x->as_oct(), $bytes, $x->as_bin(), $set, $u64, $u64, $i64, $u32, $u32, $i32, $human;
} else {
	printf "%s\n%s\n", $x->bdstr(), $x->bsstr();
}'
}
dl() {
	if (($#)); then
		local IFS=$'\n'
		dl <<<"$*"
		return
	fi
	local url file pids files i=0
	trap '
	for ((i--; i >= 0; i--)); do
		kill -9 ${pids[$i]} && rm -f "${files[$i]}"
	done
	trap - SIGINT
	' SIGINT
	while read -ep'URL: ' url && [[ -n $url ]]; do
		file=$(sed -E 's:(\?|#).*::; s:.*/::' <<<"$url") || continue
		eval curl -fsSLo \'$file\' \'$url\' '&'
		pids+=($!)
		files+=("$file")
		i=$((i + 1))
	done
	wait ${pids[@]}
	for file in ${files[@]}; do
		echo $file
	done
	trap - SIGINT
}
sush() {
	sudo -E --preserve-env=PATH,HOME $BASH --rcfile ~/.bash_profile
}
rpmt() {
	[[ $# == 1 ]] || return 1
	rpm2cpio $1 | cpio -t --quiet
}
rpmi() {
	[[ $# -lt 3 ]] || return 1
	local rpm=$1 base=${1##*/} pat tar
	if [[ ${2:-} ]]; then
		pat=$2
	elif [[ $base =~ ^kernel ]]; then
		pat=linux
	else
		pat=$(grep -Po '[a-z0-9]+(-[a-z]+)*' <<<$base | head -n1)
		[[ -n $pat ]] || return 1
	fi
	tar=$(rpmt $rpm | grep -Po '^'$pat'([-0-9.]+(\.(el|fc)[0-9_]+)?.tar.(xz|bz2|gz))?$')
	[[ -n $tar ]] || return 1
	rpm2cpio $rpm | cpio -idu --quiet $tar || return $?
	echo $tar
}
rpmia() {
	[[ $# -eq 1 ]] || return 1
	local rpm=$(readlink -f $1) dir=$(basename $1 .rpm)
	mkdir $dir || return 1
	cd $dir
	rpm2cpio $rpm | cpio -idu --quiet
}
alias rpmc='rpm -qp --changelog'
diffh() {
	local f1='sed -E '\''s:.*/::'\'
	local title="diff $(eval $f1 <<<"$1") $(eval $f1 <<<"$2")"
	local f2='sed -E '\''s:.*/::; s/(.+)\.[a-zA-Z0-9]+$/\1/'\'
	local out="diff_$(eval $f2 <<<"$1")_$(eval $f2 <<<"$2").html"
	diffl "$1" "$2" | diff2html-cli -s side --su hidden -t "$title" -i stdin -o stdout | _expand_links > "$out"
}
_expand_links() {
	local l href media cachedir=~/.cache/diffh cache
	mkdir -p $cachedir
	while read -r l; do
		if [[ $l =~ ^\<link\ rel=\"stylesheet\" ]]; then
			href=$(grep -Po '(?<=href=")[^"]+(?=")' <<<$l)
			media=$(grep -Po '(?<=media=")[^"]+(?=")' <<<$l)
			cache=$cachedir/$(basename $href)
			if [[ ! -e $cache ]]; then
				curl -fsSLo $cache $href
			fi
			echo -e "<style>\n@media $media {\n$(cat $cache)\n}\n</style>"
		else
			echo "$l"
		fi
	done
}
rm_rfchmod() {
	find "$@" ! -perm -200 -type d -print0 | xargs -0 chmod 700
	rm -rf "$@"
}
_cursor() {
	local col=${1:-ff0000}
	printf '\e]12;#'$col'\a'
	printf '\e[2 q'
}

if [[ $_uname == MSYS ]]; then
	shopt -s completion_strip_exe
	_pc3=$(sed -E 's/\$\(|\)/`/g' <<<$_pc3)
	rg() {
		command rg --hidden --path-separator // "$@"
	}
	alias open=start
	e() {
		start "${@:-.}"
	}
	upgrade() {
		pacman -Syu --noconfirm
		pacman -Qtdq | pacman -Rns --noconfirm - 2>/dev/null
	}
	_source_r /usr/share/git/git-prompt.sh
# elif [[ $_uname == Darwin ]]; then
# 	alias batt='pmset -g batt'
# 	alias scheme='chez ~/dotfiles/chezrc.ss'
# 	alias e=open
# 	alias upgrade='brew upgrade'
# 	_source_r /usr/local/etc/profile.d/bash_completion.sh
else
	e() {
		xdg-open &>/dev/null "${@:-.}"
	}
	if [[ $_uname == WSL ]]; then
		alias open=xdg-open
		xdg-open() {
			[[ $# == 0 ]] && return 1
			local arg
			while (($#)); do
				if [[ -r $1 ]]; then
					arg=$arg'"'$(wslpath -w "$1")'", '
				else
					arg=$arg'"'$1'", '
				fi
				shift
			done
			powershell.exe -NoProfile 'Invoke-Item '"${arg%, }"
		}
		diffhw() {
			local winmerge='/mnt/c/Program Files/WinMerge/WinMergeU.exe'
			local f='sed -E '\''s:.*/::; s/(.+)\.[a-zA-Z0-9]+$/\1/'\'
			local l=$(eval $f <<<"$1")
			local r=$(eval $f <<<"$2")
			local out="diff_${l}_$r.html"
			if [[ $l == $r ]]; then
				out="diff_$l.html"
			fi
			"$winmerge" -noninteractive -or "$out" "$(wslpath -w "$1")" "$(wslpath -w "$2")"
		}
	fi
	if [[ $_distro == debian ]]; then
		_pc3='${debian_chroot:+($debian_chroot)}'$_pc3
		upgrade() {
			sudo apt-get -qq update
			apt list --upgradable
			sudo apt-get -y upgrade
			sudo apt-get -qq autoremove
		}
		# _source_r /usr/lib/git-core/git-sh-prompt
	elif [[ $_distro =~ fedora|centos|rhel ]]; then
		_source_r /usr/share/git-core/contrib/completion/git-prompt.sh
	fi
fi
_source_r /etc/profile.d/bash_completion.sh
type _completion_loader &>/dev/null && ! _completion_loader ssh
complete -F _ssh tryssh
complete -c realwhich
PROMPT_COMMAND=$_pc0"; __git_ps1 '"$_pc1$_pc2$_pc3"' '"$_pc4"'"
if ! type __git_ps1 &>/dev/null; then
	PROMPT_COMMAND=$_pc0
	PS1=$_pc1$_pc2$_pc3$_pc4
fi

_source_r ~/.localbashrc.bash
true
