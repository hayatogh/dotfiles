pathmunge() {
	if [[ -d $1 && ! :$PATH: =~ :$1: ]]; then
		PATH=$1:$PATH
	fi
}
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge ~/.local/bin
pathmunge ~/.cargo/bin
export GOROOT=~/.goroot
export GOPATH=~/.gopath
pathmunge $GOROOT/bin
pathmunge $GOPATH/bin
export WASMTIME_HOME=~/.wasmtime
pathmunge $WASMTIME_HOME/bin
export DISPLAY
export CHKTEXRC=~/dotfiles/chktexrc
export FZF_DEFAULT_COMMAND='fd -tf -HILE.git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --color='\''hl:9,hl+:9,spinner:16'\'
export INPUTRC=~/dotfiles/inputrc
export LESS=-RiWM
export LS_COLORS='rs=0:di=01;34:ln=01;04;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'
export MANPAGER='vim +MANPAGER --not-a-term -'
export NPM_CONFIG_USERCONFIG=~/dotfiles/npmrc
export RLWRAP_HOME=~/.local/state/rlwrap
export RUST_BACKTRACE=1
export SCREENDIR=~/.screen
export SCREENRC=~/dotfiles/screenrc
export VISUAL=vim
export XDG_CONFIG_HOME=~/.config

export _pc0='history -a; history -c; history -r'
export _pc1='\[\e]0;\u@\h \w \d \A [\j] \a\]'
_pc1=$_pc1'\[\e[0m\]\n$PSM\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[38;5;93m\]$PSSHLVL \[\e[38;5;166m\]$([[ \j -gt 0 ]] && echo \j)\[\e[0m\]'
export _pc2=' \[\e[38;5;245m\]\t ${PIPESTATUS[@]}\[\e[0m\]\n\[\ek\e\\\]\$ '
export PROMPT_COMMAND=$_pc0"; __git_ps1 '"$_pc1"' '"$_pc2"'"
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE='pwd:bash:sr:vim:ls:la:ll:al:cd:cd -:cd ..:cd ../..:git s:git ss:git d:git dc:git dw:git ds:git dn:git dt:git g:git l:upgrade:sush'
export HISTSIZE=2000
export HISTTIMEFORMAT='%c : '
if [[ ${SUDO_USER:-} ]]; then
	export HISTFILE=~/.root_history
	export LESSHISTFILE=~/.root_lesshst
	SCREENDIR=~/.root_screen
	if [[ ! -e $SCREENDIR/$STY ]]; then
		unset STY
	fi
fi

export _uname
case $(uname -sr) in
	*icrosoft*) _uname=WSL;;
	*Linux*) _uname=Linux;;
	*Darwin*) _uname=Darwin;;
	*_NT*) _uname=MSYS;;
	*) _uname=Unknown;;
esac
export _distro=$(grep -Po '(?<=^ID=).*$' /etc/os-release 2>/dev/null || true)

if [[ $_uname == MSYS ]]; then
	export LANG=$(locale -uU)
	pathmunge /c/Users/$USER/AppData/Local/Microsoft/WinGet/Links
	pathmunge /c/Users/$USER/.cargo/bin
	GOROOT=/c/Go
	GOPATH=/c/Users/$USER/go
	pathmunge $GOROOT/bin
	pathmunge $GOPATH/bin
	export MSYS=winsymlinks:nativestrict
elif [[ $_uname == Darwin ]]; then
	pathmunge /usr/local/opt/coreutils/libexec/gnubin
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
	export INFOPATH=/usr/local/opt/coreutils/share/info:$INFOPATH
	export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
	export BASH_COMPLETION_DIR=/usr/local/share/bash-completion
else
	if [[ $_uname == WSL ]]; then
		LC_CTYPE=en_US.UTF-8
	fi
	if [[ $_distro == debian ]]; then
		export LESSOPEN='| /usr/bin/lesspipe %s'
		export LESSCLOSE='/usr/bin/lesspipe %s %s'
	fi
fi
unset pathmunge

[[ -r ~/.opam/opam-init/init.sh ]] && . ~/.opam/opam-init/init.sh
[[ -r ~/.ghcup/env ]] && . ~/.ghcup/env
[[ -r ~/.bashrc ]] && . ~/.bashrc
true
