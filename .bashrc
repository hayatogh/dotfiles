_pathadd()
{
	if [[ :$PATH: != *:$1:* ]]; then
		PATH=$1:$PATH
	fi
}
_pathadd /usr/sbin
_pathadd /usr/local/sbin
_pathadd ~/.local/bin
_pathadd ~/.cargo/bin
export GOROOT=~/.goroot
export GOPATH=~/.gopath
_pathadd $GOROOT/bin
_pathadd $GOPATH/bin
_pathadd ~/.wasmtime/bin
_pathadd ~/.npm/bin
_pathadd ~/.deno/bin
_load_if_missing()
{
	if [[ -r $2 && :$PATH: != *$1* ]]; then
		. "$2"
	fi
}
_load_if_missing .opam ~/.opam/opam-init/init.sh
_load_if_missing .ghcup ~/.ghcup/env

export DISPLAY
if [[ -r ~/dotfiles/inputrc ]]; then
	export INPUTRC=~/dotfiles/inputrc
fi
export LESS=-RiWM
if [[ -r ~/dotfiles/dircolors ]]; then
	eval "$(dircolors -b ~/dotfiles/dircolors)"
fi
export MANOPT='--nh --nj'
export MANPAGER='vim +MANPAGER --not-a-term -'
export NPM_CONFIG_USERCONFIG=~/dotfiles/npmrc
export RLWRAP_HOME=~/.local/state/rlwrap
export RUST_BACKTRACE=1
export VISUAL=vim
export XDG_CONFIG_HOME=~/.config
if [[ ${SUDO_USER:-} ]]; then
	export LESSHISTFILE=~/.root_lesshst
fi

_distro=$(sed -En 's/^ID=//p' /etc/os-release 2>/dev/null || true)
if [[ $_distro == debian ]]; then
	export LESSOPEN='| /usr/bin/lesspipe %s'
	export LESSCLOSE='/usr/bin/lesspipe %s %s'
fi


[[ $- != *i* ]] && return

shopt -s autocd cdspell checkhash checkjobs checkwinsize dotglob execfail globstar histreedit lithist no_empty_cmd_completion nocaseglob

_nj='\j'
_pc0='history -a; history -c; history -r; _pj=${_nj@P}; _pj=${_pj#0}'
_pc1='\[\e[0m\]\n'
_pc2='$PSM\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[38;5;93m\]$PSSHLVL \[\e[38;5;166m\]$_pj\[\e[0m\]'
_pc3=' \[\e[38;5;245m\]\t ${PIPESTATUS[@]}\[\e[0m\]\n\[\ek\e\\\]\$ '
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=2000
HISTTIMEFORMAT='%c : '
if [[ ${SUDO_USER:-} ]]; then
	HISTFILE=~/.root_history
fi

PSSHLVL=$((SHLVL ${TMUX:+- 1}))
if ((PSSHLVL == 1)); then
	PSSHLVL=
fi
PSM=${PSM:-}
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp -p'
alias diff='diff --color=auto'
alias ee=exit
alias fd='fd -HE.git/'
alias fdall='fd -I'
alias grep='grep --color=auto'
alias info='info --init-file ~/dotfiles/infokey'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alhF'
alias manless='man -P less'
alias rm='rm -i'
alias scheme='scheme ~/dotfiles/chezrc.ss'
alias tm='tmux new -ADX'
alias vi='vim --clean'
e()
{
	open &>/dev/null "${@:-.}"
}
tryssh()
{
	(($# == 1 || $# == 2)) || return 1
	local host=$1 interval=${2:-5} m nl=''
	while true; do
		m=$(ssh -o BatchMode=yes $host /bin/true 2>&1)
		if [[ $m == '' || $m =~ 'Permission denied' ]]; then
			printf "$nl"
			break
		fi
		nl='\n'
		printf .
		sleep $interval
	done
	ssh $1
}
mkcd()
{
	mkdir "$1"
	cd "$1"
}
_regex_rubout()
{
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ $1 ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_LINE=$left$right
	READLINE_POINT=${#left}
}
_cw()
{
	_regex_rubout '([a-zA-Z0-9]+|[^ a-zA-Z0-9]+) *$'
}
bind -x '"\C-w": _cw'
bind -x '"\eh": _cw'
_mbackslash()
{
	_regex_rubout '([^ ;&|<>] *)*(;|&&|\|\||\||\|&|<|>|<<|>>|&>|>&)? *$'
}
bind -x '"\e\\": _mbackslash'
cdd()
{
	cd "$(dirname "$1")"
}
mktags()
{
	if [[ -f Kbuild ]]; then
		local arch=x86
		if [[ ${1:-} =~ arm ]]; then
			arch=arm64
		fi
		rm -f tags
		make SRCARCH=$arch tags &>/dev/null
		mv tags tags.$arch
		ln -s tags.$arch tags
	elif (($# == 0)); then
		ctags -R &>/dev/null
	else
		ctags "$@" &>/dev/null
	fi
}
realwhich()
{
	realpath "$(which "$1")"
}
clean_history()
{
	(($# == 1)) || return 1
	local pat=$1
	perl -0777 -i -pe 's/^#\d+\n('"$pat"') *\n//gm' $HISTFILE
}
fix_history()
{
	perl -i -ne 'BEGIN { $sawtime = 0 } if (/^#/) { $sawtime = 1 } if ($sawtime) { print }' $HISTFILE
}
fixmod()
{
	find "$@" -maxdepth 0 -type d -print0 | xargs -0 chmod 755
	find "$@" -maxdepth 0 -type f -print0 | xargs -0 chmod 644
}
alias rgall='command rg --no-messages --hidden --no-ignore -g!tags -g!tags.x86 -g!tags.arm64 -g!.git/'
alias rg='rgall --ignore -g!/po/*.po -g!/Documentation/translations'
_rg_arch()
{
	rg $(find arch/ -mindepth 1 -maxdepth 1 -type d -printf '-g!%f/ ' | sed -E 's:-g!('"$1"')/ ::') "${@:2}"
}
alias rgx='_rg_arch x86'
alias rgarm='_rg_arch '\''arm|arm64'\'
vl()
{
	vim $($1 -l "${@:2}")
}
vll()
{
	vim $("$@")
}
calc()
{
	perl -e '
use strict;
use bignum;

my $x = $ARGV[0];
$x =~ s/[kK]i?[bB]?/*(1<<10)/g;
$x =~ s/[mM]i?[bB]?/*(1<<20)/g;
$x =~ s/[gG]i?[bB]?/*(1<<30)/g;
$x =~ s/[tT]i?[bB]?/*(1<<40)/g;
$x =~ s/[pP]i?[bB]?/*(1<<50)/g;
$x = eval $x;
if ($x->is_int()) {
	$x = $x->as_int();
	my $u64 = $x & 0xffffffffffffffff;
	my $i64 = $u64 >> 63 ? -1 * (($u64 ^ 0xffffffffffffffff) + 1) : $u64;
	my $u32 = $x & 0xffffffff;
	my $i32 = $u32 >> 31 ? -1 * (($u32 ^ 0xffffffff) + 1) : $u32;
	my $set, my $human, my $bytes;
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
	printf <<EOT, $x->as_hex(), $x->bdstr(), $x->bnstr(), $x->bestr(), $x->as_oct(), $bytes, $x->as_bin(), $set, $u64, $u64, $i64, $u32, $u32, $i32, $human;
hex:      %s
decimal:  %s %s %s
octal:    %s
string:   %s
binary:   %s
bits set: %s
64 bit:   %#x %u %d
32 bit:   %#x %u %d
human:    %s
EOT
} else {
	printf "%s\n%s\n", $x->bdstr(), $x->bsstr();
}
' -- "$*"
}
dl()
{
	if (($#)); then
		local IFS=$'\n'
		$FUNCNAME <<<"$*"
		return
	fi
	local url file pids files i=0
	trap '
	for ((i--; i >= 0; i--)); do
		kill -9 ${pids[$i]} &>/dev/null && rm -f "${files[$i]}"
	done
	trap - SIGINT
	return
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
alias sush='sudo --preserve-env=HOME $BASH --rcfile ~/.bashrc'
_load_if_readable()
{
	if [[ -r $1 ]]; then
		. "$1"
	fi
}
_load_if_readable ~/dotfiles/rpm-commands.sh
rm_rfchmod()
{
	find "$@" ! -perm -700 -type d -print0 | xargs -0 chmod 700
	rm -rf "$@"
}
timesp()
{
	if (($#)); then
		$FUNCNAME <<<"$*"
		return
	fi
	# 1y == 365d 6h
	# 1month == 30d 10h 30m
	local rest tok exp_sec=
	while read -e rest && [[ -n $rest ]]; do
		while [[ $rest ]]; do
			[[ $rest =~ ([^-+*/]+|[-+*/] *) ]]
			tok=${BASH_REMATCH[0]}
			rest=${rest:${#BASH_REMATCH[0]}}
			if [[ $tok =~ ^[-+*/] ]]; then
				exp_sec="$exp_sec$tok "
			else
				exp_sec="$exp_sec$(systemd-analyze --user timespan -- "$tok" | sed -En '/μs/s/(.*: |000000$)//gp') "
			fi
		done
		systemd-analyze --user timespan -- $(($exp_sec)) | sed -En '/Original|Human/s/.*: //p'
	done
}
loredl()
{
	(($# == 1)) || return 1
	local link=$1 msgid url
	msgid=$(grep -Eo '[^/]+@[^/]+' <<<$link)
	url=https://lore.kernel.org/all/$msgid/t.mbox.gz
	curl -fsSLo "$msgid.mbox.gz" "$url"
}

if [[ $_distro == debian ]]; then
	_pc2='${debian_chroot:+($debian_chroot)}'$_pc2
	upgrade()
	{
		sudo apt-get -qq update
		sudo apt-get -y dist-upgrade
		sudo apt-get -qq autoremove
	}
	# _load_if_readable /usr/lib/git-core/git-sh-prompt
elif [[ $_distro =~ fedora|centos|rhel ]]; then
	upgrade()
	{
		sudo dnf upgrade
	}
	alias which &>/dev/null && unalias which
	unset -f which
	alias l. &>/dev/null && unalias l.
	_load_if_readable /usr/share/git-core/contrib/completion/git-prompt.sh
fi

l.()
(
	(($#)) && cd "$1"
	ls -dF .*
)
_load_if_readable /etc/profile.d/bash_completion.sh
if type _comp_load &>/dev/null; then
	_comp_load -D -- ssh
	complete -F _comp_cmd_ssh tryssh
fi
complete -c realwhich
PROMPT_COMMAND=$_pc0"; __git_ps1 '"$_pc1$_pc2"' '"$_pc3"'"
if ! type __git_ps1 &>/dev/null; then
	PROMPT_COMMAND=$_pc0
	PS1=$_pc1$_pc2$_pc3
fi

_load_if_readable ~/.localbashrc.bash
true
