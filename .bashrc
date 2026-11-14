_pathadd()
{
	if [[ :$PATH: != *:$1:* ]]; then
		PATH=$1:$PATH
	fi
}
_load_if_readable()
{
	if [[ -r $1 ]]; then
		. "$1"
	fi
}
_load_if_missing()
{
	if [[ :$PATH: != *$1* ]]; then
		_load_if_readable "$2"
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
_pathadd ~/dotfiles/bin
_load_if_missing .opam ~/.opam/opam-init/init.sh
_load_if_missing .ghcup ~/.ghcup/env

export DISPLAY
if [[ -r ~/dotfiles/inputrc ]]; then
	export INPUTRC=~/dotfiles/inputrc
fi
if [[ $LANG =~ ^ja_JP\.(utf|UTF-)8$ ]]; then
	LANG=C.utf8
fi
export LESS=-RiWM
if [[ -z ${LESSOPEN:-} ]] && type lesspipe &>/dev/null; then
	eval "$(lesspipe)"
fi
export LIBVIRT_DEFAULT_URI=qemu:///system
if [[ -r ~/dotfiles/dircolors ]]; then
	eval "$(dircolors -b ~/dotfiles/dircolors)"
fi
export MANOPT='--nh --nj'
export MANPAGER='vi +MANPAGER --not-a-term -'
export NPM_CONFIG_USERCONFIG=~/dotfiles/npmrc
export RLWRAP_HOME=~/.local/state/rlwrap
export RUST_BACKTRACE=1
export VISUAL=vi
export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config
if [[ ${SUDO_USER:-} ]]; then
	export LESSHISTFILE=~/.local/state/root_lesshst
fi

[[ $- != *i* ]] && return

if [[ -z $BASH_COMPLETION_VERSINFO ]]; then
	_load_if_readable /etc/profile.d/bash_completion.sh
fi
if ! type __git_ps1 &>/dev/null; then
	_load_if_readable /usr/share/git-core/contrib/completion/git-prompt.sh
fi

_regex_rubout()
{
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ $1 ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_POINT=${#left}
	READLINE_LINE=$left$right
}
_cw() { _regex_rubout '([a-zA-Z0-9]+|[^ a-zA-Z0-9]+) *$'; }
bind -x '"\C-w": _cw'
_mbackslash() { _regex_rubout '([^ ;&|<>] *)*(;|&&|\|\||\||\|&|<|>|<<|>>|&>|>&)? *$'; }
bind -x '"\e\\": _mbackslash'

shopt -s autocd cdspell checkhash checkjobs checkwinsize dotglob execfail globstar histreedit lithist no_empty_cmd_completion nocaseglob

HISTCONTROL=ignoreboth:erasedups
HISTFILESIZE=-1
HISTSIZE=20000
HISTTIMEFORMAT='%c : '
if [[ ${SUDO_USER:-} ]]; then
	HISTFILE=~/.root_history
fi
_hist_func()
{
	local f=$1 cmd=$2
	local pre='{ flock 9;' post="} 9>'$XDG_CACHE_HOME/.bash_history.lock';"
	if ! type flock &>/dev/null; then
		pre= post=
	fi
	eval "$f() { $pre $cmd; $post }"
}
_hist_func _hist_sync 'history -a && history -c && history -r'
_hist_func _hist_exit 'history -a && history -c && history -r && history -w'
unset -f _hist_func
trap _hist_exit EXIT
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCONFLICTSTATE=yes
GIT_PS1_DESCRIBE_STYLE=tag
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_HIDE_IF_PWD_IGNORED=1
GIT_PS1_SKIPDIRS=
GIT_PS1_SKIPSEC=3
_psl=$((SHLVL ${TMUX:+- 1}))
if ((_psl == 1)); then
	_psl=
fi
_nj='\j'
_pc0='_hist_sync; _pj=${_nj@P}; _pj=${_pj#0}'
_pc1='\[\e[0m\]\n'
_pc2='\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[38;5;93m\]$_psl \[\e[38;5;166m\]$_pj\[\e[0m\]'
_pc3=' \[\e[38;5;245m\]\t ${PIPESTATUS[@]}\[\e[0m\]\n\$ '
_pc()
{
	local gitdir start took
	eval "$_pc0"
	gitdir=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z $gitdir ]]; then
		PS1=$_pc1$_pc2$_pc3
		return
	fi
	if [[ :${GIT_PS1_SKIPDIRS:-}: == *:$gitdir:* ]]; then
		PS1=$_pc1$_pc2' -'$_pc3
		return
	fi
	start=$EPOCHSECONDS
	local GIT_PS1_SHOWUPSTREAM=$GIT_PS1_SHOWUPSTREAM
	__git_ps1 "$_pc1$_pc2" "$_pc3"
	took=$((EPOCHSECONDS - start))
	if [[ $took -ge $GIT_PS1_SKIPSEC ]]; then
		echo "Git prompt took $took >=GIT_PS1_SKIPSEC.  Added to GIT_PS1_SKIPDIRS."
		GIT_PS1_SKIPDIRS=${GIT_PS1_SKIPDIRS:+$GIT_PS1_SKIPDIRS:}$gitdir
	fi
}
PROMPT_COMMAND=_pc
if ! type __git_ps1 &>/dev/null; then
	_pc0=$_pc0'; return'
	PS1=$_pc1$_pc2$_pc3
fi

alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias diff='diff --color'
alias fd='fd -HE.git/'
alias fdall='fd -I'
alias grep='grep --color'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alhF'
alias manless='man -P less'
alias rm='rm -i'
alias scheme='scheme --eehistory ~/.local/state/chez_history ~/dotfiles/chezrc.ss'
alias sush='sudo --preserve-env=HOME $BASH --rcfile ~/.bashrc'
alias tm='tmux new -ADX'
alias l. &>/dev/null && unalias l.
l.() ( cd -- "${1:-.}"; ls -d .*; )
e() { open "${@:-.}" &>/dev/null; }
mkcd() { mkdir -- "$1"; cd -- "$1"; }
cdd() { cd -- "$(dirname -- "$1")"; }
realfile() { realpath -- "$(command -v -- "$1")"; }
rm_rfchmod() { chmod -R 700 -- "$@"; rm -rf -- "$@"; }
rgall() { command rg --no-messages --hidden --no-ignore -g!tags -g!tags.x86 -g!tags.arm64 -g!tags~ -g!.git/ "$@"; }
rg() { rgall --ignore -g!/po/*.po -g!/Documentation/translations "$@"; }
_rg_arch() { rg $(find arch/ -mindepth 1 -maxdepth 1 -type d -printf '-g!%f/ ' | sed -E 's:-g!('"$1"')/ ::') "${@:2}"; }
rgx() { _rg_arch x86 "$@"; }
rgarm() { _rg_arch 'arm|arm64' "$@"; }
vl() { vi $($1 -l "${@:2}"); }
vll() { vi $("$@"); }
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
_load_if_readable ~/dotfiles/rpm-commands.sh

_comp_copy()
{
	local srccmd=$1 destcmd=$2 spec
	shift
	$(complete -pD | awk '{print $(NF-1)}') $srccmd
	spec=$(complete -p $srccmd)
	$(awk '{$NF="'$destcmd'"; print}' <<<$spec)
	$(awk '{print $(NF-1)}' <<<$spec) "$@"
}
_comp_copy_ssh()
{
	_comp_copy ssh "$@"
}
complete -F _comp_copy_ssh tryssh
complete -c realwhich
_comp_kconfig_make()
{
	if [[ -r scripts/bash-completion/make ]]; then
		. scripts/bash-completion/make
	else
		$(complete -pD | awk '{print $(NF-1)}') make
	fi
	$(awk '{print $(NF-1)}' <<<$(complete -p make)) "$@"
}
complete -F _comp_kconfig_make make

_load_if_readable ~/.localbashrc.bash

if [[ -z ${_nomx:-} && -z ${TMUX:-} && -z ${SUDO_USER:-} && -z $(tmux lsc 2>/dev/null) ]]; then
	tmux new -A
fi
true
