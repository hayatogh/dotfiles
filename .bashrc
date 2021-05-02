[[ ! $- =~ i ]] && return
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
alias fd="fd -HE.git"
alias git_dotfiles_pull="git -C ~/dotfiles pull"
alias git_empty_commit="git a -A && git c -m 'No commit message' && git push"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias la="ls -AF"
alias ll="ls -lhF"
alias al="ls -alhF"
alias ltime="ls -alhrtF"
alias lsize="ls -alhrFS"
alias manless="man -P less"
alias mkdir="mkdir -p"
alias rg="rg --hidden -g'!.git'"
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
l.() {
	([[ $# != 0 ]] && cd $1; ls -dF .*)
}
tryssh() {
	local sleeptime=5
	[[ $# == 0 ]] && return 1
	[[ $# == 2 ]] && sleeptime=$2
	while printf "."; do
		ssh $1 true &>/dev/null && printf "\n" && break
		sleep $sleeptime
	done
	ssh $1
}
mkcd() {
	\mkdir $1
	cd $1
}
_cw() {
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ ([a-zA-Z]+|[0-9]+|.)\ *$ ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_LINE=$left$right
	READLINE_POINT=${#left}
}
bind -m vi-insert  -x '"\C-w": _cw'
bind -m vi-command -x '"\C-w": _cw'
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
stopwatch() {
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
_psjobs() {
	PSJOBS=$(jobs -p)
	if [[ -z $PSJOBS ]]; then
		PSJOBS=""
	else
		PSJOBS=$(ps -opid= $PSJOBS | wc -l)
		if [[ $PSJOBS == 0 ]]; then
			PSJOBS=""
		fi
	fi
}
if ! type realpath &>/dev/null; then
	realpath() {
		local i
		for i in $@; do
			(cd $i && pwd -P)
		done
	}
fi
cdd() {
	if [[ $# == 0 ]]; then
		cd
	else
		cd $(dirname $1)
	fi
}

if [[ $_uname =~ NT-10.0 ]]; then
	shopt -s completion_strip_exe
	alias chocoupgrade="$HOME/dotfiles/choco-upgrade.bat"
	alias e=explorer.exe
	alias javac="javac -encoding UTF-8"
	alias java="java -Dfile.encoding=UTF-8"
	if [[ $javaenc == MS932 ]]; then
		alias javac="javac -encoding MS932"
		alias java="java -Dfile.encoding=MS932"
	fi
	alias open=start
	# phpdir=$(ls -d /c/tools/php* | tail -n1)
	# alias php="$phpdir/php.exe"
	# unset phpdir
	alias rg="rg --path-separator '\x2F'"
	upgrade() {
		pacman -Qtdq | pacman -Rns --noconfirm - 2>/dev/null
		pacman -Syu --noconfirm
	}
	_psjobs() {
		PSJOBS=$(jobs -p)
		if [[ -z $PSJOBS ]]; then
			PSJOBS=""
		else
			PSJOBS=$(wc -l <<<$PSJOBS)
		fi
	}
elif [[ $_uname == Darwin ]]; then
	[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . /usr/local/etc/profile.d/bash_completion.sh
	alias batt="pmset -g batt"
	macbin() {
		PATH=$_OLDPATH $@
	}
	upgrade() {
		brew upgrade
	}
elif [[ $_uname == Linux ]]; then
	alias open='xdg-open &>/dev/null'
	pdfx() {
		wine start "C:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe" "$@" &>/dev/null &
	}
	if [[ $(uname -r) =~ Microsoft ]]; then
		alias e=explorer.exe
		xdg-open() {
			powershell.exe '& \\wsl$\Debian\'$(realpath $1)
		}
	fi
	# distro=$(cat /etc/*-release)
	_distro=$(\grep -Pom1 '(?<=^ID=).*$' /etc/os-release)
	if [[ $_distro == debian ]]; then
		upgrade() {
			sudo apt-get -qq autoremove
			sudo apt-get -qq update
			apt list --upgradable
			sudo apt upgrade -y
		}
	fi
fi

[[ -r ~/dotfiles/git-prompt.sh ]] && . ~/dotfiles/git-prompt.sh
[[ -r /etc/profile.d/bash_completion.sh ]] && . /etc/profile.d/bash_completion.sh
type _completion_loader &>/dev/null && _completion_loader ssh
complete -F _ssh tryssh
[[ -r ~/.localbashrc.sh ]] && . ~/.localbashrc.sh
true
