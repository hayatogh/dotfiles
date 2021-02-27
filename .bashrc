#!/usr/bin/env bash
# [[ -f /etc/bashrc ]] && . /etc/bashrc
# [[ -f /etc/bash.bashrc ]] && . /etc/bash.bashrc
shopt -s autocd cdspell checkjobs checkwinsize dotglob globstar lithist no_empty_cmd_completion nocaseglob
if [[ $TERM =~ screen ]]; then
	if [[ $SHLVL > 2 ]]; then
		PSSHLVL=$(($SHLVL - 1))
	fi
elif [[ $SHLVL > 1 ]]; then
	PSSHLVL=$SHLVL
fi
alias :e=vim
alias bc="bc -l"
alias cd..="cd .."
alias chgrp="chgrp --preserve-root"
alias chmod="chmod --preserve-root"
alias chown="chown --preserve-root"
alias cp="cp -p"
alias dus="du -chs"
alias diff="diff --color=auto"
alias ee=exit
alias fd="fd -H"
alias git_dotfiles_pull="git -C ~/dotfiles pull"
alias git_empty_commit="git a -A && git c -m 'No commit message' && git push"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias la="\ls -AF --color=auto"
alias l.=_ldot
alias ll="\ls -lhF --color=auto"
alias al="\ls -alhF --color=auto"
alias lt="\ls -alhrtF --color=auto"
alias manless="man -P less"
alias mkdir="mkdir -p"
alias pip3_upgrade_outdated="pip_upgrade_outdated -3"
alias rm="rm -i"
alias sc="script -qc sh"
alias sr="screen -D -R"
alias vi="vim --clean"
alias vu="vagrant up"
alias vus="vu ; vs"
alias vush="vu ; vs ; vh"
alias vs="vagrant ssh"
alias vh="vagrant halt"
alias wget="wget -N"
alias which=_which
_which()
{
	if [[ $(type -t "${@: -1}" 2>&1) == builtin ]]; then
		type -t "${@: -1}"
	fi
	(alias; declare -f) | \
		\which --tty-only --read-alias --read-functions --show-tilde --show-dot $@
}
killgrep()
{
	[[ $# != 0 ]] && \
		ps x | \grep $1 | awk '{print $1}' | xargs kill -9 &>/dev/null
}
_ldot()
{
	if [[ $# == 0 ]]; then
		\ls -dF .* --color=auto
	else
		(cd $1 && \ls -dF .* --color=auto)
	fi
}
tryssh()
{
	local sleeptime=5
	[[ $# == 0 ]] && return 1
	[[ $# == 2 ]] && sleeptime=$2
	while printf "."; do
		ssh $1 true &>/dev/null && printf "\n" && break
		sleep $sleeptime
	done
	ssh $1
}
mkcd()
{
	\mkdir $1
	cd $1
}
_cw() {
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ ([^[:alnum:]]|[[:digit:]]*|[[:alpha:]]*)[[:space:]]*$ ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_LINE=$left$right
	READLINE_POINT=${#left}
}
if [[ $- =~ i ]]; then
	bind -m vi-insert  -x '"\C-w": _cw'
	bind -m vi-command -x '"\C-w": _cw'
fi
_quick_man() {
	local preferhelp=0    # Use "command --help" instead of man pages if possible
	local prefercheat=1

	local argv argv0 argv1 tmp cmd
	IFS=" " read -ra argv <<<$@
	argv0=${argv[0]}
	argv1=${argv[1]}
	# expand bash alias
	if [[ $(type -t $argv0 2>&1) == alias ]]; then
		IFS=" " read -ra tmp <<<${BASH_ALIASES[$argv0]}
		argv0=${tmp[0]}
		if [[ ${#tmp[@]} -ge 2 ]]; then
			argv1=${tmp[1]}
		fi
	fi
	# printf "$argv0\n$argv1\n"  # debug

	tmp=$(type -t $argv0 2>&1)
	if [[ $tmp == keyword ]]; then
		return
	elif [[ $tmp == builtin ]]; then
		cmd="help $argv0 | less"
	elif [[ $tmp == function ]]; then
		cmd="type $argv0 | less"
	elif [[ $argv0 == git ]] && [[ ! -z $argv1 ]]; then
		tmp=$(git config alias.$argv1 2>/dev/null)
		if [[ -n $tmp ]]; then
			argv1=$tmp
		fi
		cmd="man -S \"1\" git-$argv1"
	elif [[ $argv0 =~ ^rustup$|^go$ ]]; then
		cmd="$argv0 help $argv1 | less"
	elif [[ $argv0 == cargo ]]; then
		cmd="$argv0 help $argv1"
	elif (( $prefercheat )) && cheat $argv0 &>/dev/null; then
		cmd="cheat $argv0"
	elif (( $preferhelp )) && $argv0 --help &>/dev/null; then
		cmd="$argv0 --help | less"
	else
		cmd="man -S \"1:8:7\" $argv0"
	fi
	# printf "$cmd\n"  # debug
	eval "$cmd"
	return 0
}
upgrade() {
	local uname=$(uname)
	if [[ $uname == Linux ]]; then
		local distro=$(grep -P -o -m1 '(?<=^ID=).*$' /etc/os-release)
		if [[ $distro == debian ]]; then
			sudo apt-get -qq autoremove
			sudo apt-get -qq update
			apt list --upgradable
			sudo apt upgrade -y
		fi
	elif [[ $uname =~ NT-10.0 ]]; then
		pacman -Qtdq | pacman -Rns --noconfirm - 2>/dev/null
		pacman -Syu --noconfirm
	elif [[ $uname == Darwin ]]; then
		brew upgrade
	fi
}
stopwatch()
{
	local c
	printf "%(%F %T)T\n"
	time \
		while true; do
			printf "%(%F %T)T\r"
			read -N 1 -t .5 c
			if [[ -n $c && $c != $'\n' ]]; then
				break
			fi
		done
}

. ~/dotfiles/git-prompt.sh
complete -F _ssh tryssh
uname=$(uname)
# msys2 mingw64
if [[ $uname =~ NT-10.0 ]]; then
	alias rg="rg --path-separator '\x2F'"
	shopt -s completion_strip_exe
	# phpdir=$(ls -d /c/tools/php* | tail -n1)
	# alias php="$phpdir/php.exe"
	# unset phpdir
	alias chocoupgrade="$HOME/dotfiles/choco-upgrade.bat"
	alias e=explorer.exe
	alias javac="javac -encoding UTF-8"
	alias java="java -Dfile.encoding=UTF-8"
	if [[ $javaenc == MS932 ]]; then
		alias javac="javac -encoding MS932"
		alias java="java -Dfile.encoding=MS932"
	fi
fi
if [[ $uname == Darwin ]]; then
	[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] \
		&& . /usr/local/etc/profile.d/bash_completion.sh
	alias batt="pmset -g batt"
	macbin()
	{
		PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Library/Apple/bin:/Library/TeX/texbin:/opt/X11/bin" $@
	}
fi
if [[ $uname == Linux ]]; then
	# distro=$(cat /etc/*-release)
	pdfx()
	{
		if [[ $# == 0 ]]; then
			wine start "C:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe" &>/dev/null &
		else
			wine start "C:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe" "$@" &>/dev/null &
		fi
	}
	if type fdfind &>/dev/null; then
		alias fd="fdfind -H"
	fi
	if type explorer.exe &>/dev/null; then
		alias e=explorer.exe
	fi
fi
unset uname

[[ -f /etc/profile.d/bash_completion.sh ]] && . /etc/profile.d/bash_completion.sh
type _completion_loader &>/dev/null && _completion_loader ssh
[[ -f ~/.localbashrc.sh ]] && . ~/.localbashrc.sh
true
