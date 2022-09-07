[[ ! $- =~ i ]] && return
shopt -s autocd cdspell checkjobs checkwinsize dotglob globstar lithist no_empty_cmd_completion nocaseglob
PSSHLVL=
if [[ $TERM =~ screen ]]; then
	if [[ $SHLVL > 2 ]]; then
		PSSHLVL=$(($SHLVL - 1))
	fi
elif [[ $SHLVL > 1 ]]; then
	PSSHLVL=$SHLVL
fi
if [[ ! -v $PSM ]]; then
	PSM=
fi
alias bc="bc -l"
alias chgrp="chgrp --preserve-root"
alias chmod="chmod --preserve-root"
alias chown="chown --preserve-root"
alias cp="cp -p"
alias dus="du -chs"
alias diff="diff --color=auto"
alias ee=exit
alias fd="fd -HIE.git"
alias git_dotfiles_pull="git -C ~/dotfiles pull"
alias git_empty_commit="git a -A && git c -m 'No commit message' && git push"
alias grep="grep --color=auto"
alias info="info --init-file ~/dotfiles/infokey"
alias ls="ls --color=auto"
alias la="ls -AF"
alias ll="ls -lhF"
alias al="ls -alhF"
alias ltime="ls -alhrtF"
alias lsize="ls -alhrFS"
alias man="manvim"
alias rg="rg --hidden -g'!.git'"
alias rgall="rg -uug'!.git'"
alias rm="rm -i"
alias sc="script -qc sh"
alias scheme="scheme ~/dotfiles/chezrc.ss"
alias sr="screen -D -R"
alias vi="vi --clean"
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
	mkdir $1
	cd $1
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
	_regex_rubout '([a-zA-Z]+|[0-9]+|.) *$'
}
bind -m vi-insert  -x '"\C-w": _cw'
bind -m vi-command -x '"\C-w": _cw'
_msemicolon() {
	_regex_rubout '[^;|<>]*(;|\||<|>)? *$'
}
bind -m vi-insert  -x '"\e;": _msemicolon'
bind -m vi-command -x '"\e;": _msemicolon'
stopwatch() {
	local c t acc=0 start=${EPOCHREALTIME/./} int=${1:-.1}
	[[ $int < 0.1 ]] && read -N 1 -t .1 c
	while true; do
		read -N 1 -t $int c
		t=$(($acc + ${EPOCHREALTIME/./} - $start))
		printf "\r${t:: -6}.${t: -6}"

		if [[ -z $c || $c == $'\n' ]]; then
			continue
		elif [[ $c == ' ' ]]; then
			printf "\n"
			acc=$t
			read -N 1 c
			start=${EPOCHREALTIME/./}
			printf "\n"
		else
			break
		fi
	done
}
cdd() {
	if [[ $# == 0 ]]; then
		cd
	else
		cd $(dirname $1)
	fi
}
ctags_exclude() {
	local state=exclude arg
	while (( $# )); do
		case "$1" in
			-h|--help)
				echo "$0: $0 FILE ... [--include FILE ...]"
				return
				;;
			--include)
				state="include"
				shift
				;;
			*)
				if [[ $state == exclude ]]; then
					arg="$arg--exclude=$1 "
				else
					arg=$(sed 's/--exclude='$1' //g' <<<"$arg")
				fi
				shift
				;;
		esac
	done
	echo "ctags -R $arg"
	ctags -R $arg
}
realwhich() {
	realpath $(which $1)
}
clean_history() {
	local pat=${1:-pwd|(|ba|da|z)sh|sr|vim?|make|l[sal.]|al|git .|cd(| -| \.\.)|scheme}
	perl -0777 -pi -e 's/^#\d+\n('"$pat"') *\n//gm' $HISTFILE
}
fixmod() {
	if [[ ${1:-} == -r ]]; then
		shift
		fixmod "${@/%//**}"
		return
	fi
	local x
	for x in $@; do
		if [[ -d $x ]]; then
			chmod 755 $x
		else
			chmod 644 $x
		fi
	done
}
manvim() {
	vim +"MYMANPAGER $*"
}

if [[ $_uname == MSYS ]]; then
	shopt -s completion_strip_exe
	alias e=explorer.exe
	alias open=start
	alias rg="rg --hidden -g'!.git' --path-separator '//'"
	alias rgall="rg -uug'!.git' --path-separator '//'"
	upgrade() {
		pacman -Qtdq | pacman -Rns --noconfirm - 2>/dev/null
		pacman -Syu --noconfirm
	}
	_psjobs() {
		PSJOBS=$(jobs -p)
		if [[ -n $PSJOBS ]]; then
			PSJOBS=$(wc -l <<<$PSJOBS)
		fi
	}
	[[ -r /usr/share/git/git-prompt.sh ]] && . /usr/share/git/git-prompt.sh
elif [[ $_uname == Darwin ]]; then
	alias batt="pmset -g batt"
	alias scheme="chez ~/dotfiles/chezrc.ss"
	upgrade() {
		brew upgrade
	}
	_psjobs() {
		PSJOBS=$(jobs -p)
		if [[ -n $PSJOBS ]]; then
			PSJOBS=$(ps -opid= -p$PSJOBS | wc -l)
			if [[ $PSJOBS == 0 ]]; then
				PSJOBS=
			fi
		fi
	}
	[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . /usr/local/etc/profile.d/bash_completion.sh
else
	open() {
		if [[ $# == 0 ]]; then
			xdg-open &>/dev/null .
		else
			xdg-open &>/dev/null $@
		fi
	}
	alias e=open
	pdfx() {
		wine start "C:\Program Files\Tracker Software\PDF Editor\PDFXEdit.exe" "$@" &>/dev/null &
	}
	_psjobs() {
		PSJOBS=$(jobs -p)
		if [[ -n $PSJOBS ]]; then
			PSJOBS=$(ps -opid= $PSJOBS | wc -l)
			if [[ $PSJOBS == 0 ]]; then
				PSJOBS=
			fi
		fi
	}
	if [[ $_uname == WSL ]]; then
		xdg-open() {
			[[ $# == 0 ]] && return 1
			local arg
			while (( $# )); do
				if [[ -r $1 ]]; then
					arg=$arg'"'$(wslpath -w "$1")'", '
				else
					arg=$arg'"'$1'", '
				fi
				shift
			done
			powershell.exe -NoProfile 'Invoke-Item '"${arg%, }"
		}
	fi
	if [[ $_distro == debian ]]; then
		upgrade() {
			sudo apt-get -qq autoremove
			sudo apt-get -qq update
			apt list --upgradable
			sudo apt upgrade -y
		}
	elif [[ $_distro =~ ^(fedora|centos|rhel)$ ]]; then
		[[ -r /usr/share/git-core/contrib/completion/git-prompt.sh ]] && . /usr/share/git-core/contrib/completion/git-prompt.sh
	fi
fi

printf "\e]12;#ff00ff\a"
printf "\e[2 q"

[[ -r /etc/profile.d/bash_completion.sh ]] && . /etc/profile.d/bash_completion.sh
type _completion_loader &>/dev/null && _completion_loader ssh
complete -F _ssh tryssh
complete -c realwhich
[[ -r ~/.localbashrc.sh ]] && . ~/.localbashrc.sh
true
