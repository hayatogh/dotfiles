PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
export GOROOT="$HOME/.goroot"
export GOPATH="$HOME/.gopath"
PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
export WASMTIME_HOME="$HOME/.wasmtime"
PATH="$WASMTIME_HOME/bin:$PATH"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export INFOPATH
export DISPLAY
export CHKTEXRC="$HOME/dotfiles/chktexrc"
export EDITOR=vim
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --color='hl:9,hl+:9,spinner:16'"
export LESS=-RiWM
export MANPAGER="vim +MYMANPAGER -"
export MYPY_CACHE_DIR="$HOME/.cache/mypy"
export RLWRAP_HOME="$HOME/.config/rlwrap"
export RUST_BACKTRACE=1
export SCREENDIR="$HOME/.screen"
export SCREENRC="$HOME/dotfiles/screenrc"
export VISUAL=vim
export XDG_CONFIG_HOME="$HOME/.config"

pc='_psjobs; history -a; history -c; history -r; __git_ps1 "'
pc=$pc'\[\e[0m\]\[\e]0;\u@\h '
[[ -n $MSYSTEM ]] && pc=$pc'$MSYSTEM '
pc=$pc'\w \d \A [\j] \a\]'
pc=$pc'\n$PSM\[\e[32m\]\u@\h '
[[ -n $MSYSTEM ]] && pc=$pc'\[\e[35m\]$MSYSTEM '
pc=$pc'\[\e[33m\]\w \[\e[38;5;93m\]$PSSHLVL \[\e[38;5;166m\]$PSJOBS\[\e[0m\]'
pc=$pc'" " \[\e[38;5;245m\]\t \${PIPESTATUS[@]}\[\e[0m\]\n\[\ek\e\\\\\]\\$ "'
export PROMPT_COMMAND=$pc
unset pc
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=2000
export HISTTIMEFORMAT="%c : "

export _uname=$(uname -o 2>/dev/null || uname -s)
if [[ $_uname == GNU/Linux ]] && [[ $(uname -r) =~ [Mm]icrosoft ]]; then
	_uname=WSL
fi
export _distro=$(grep -Po '(?<=^ID=).*$' /etc/os-release 2>/dev/null || true)

if [[ $_uname == Msys ]]; then
	export LANG=$(locale -uU)
	PATH="/c/ProgramData/chocolatey/bin:$PATH"
	# PATH="/c/HashiCorp/Vagrant/bin:$PATH"
	# PATH="/c/Users/$USER/.cargo/bin:$PATH"
	# GOROOT=/c/Go
	# GOPATH="/c/Users/$USER/go"
	# PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
	export MSYS=winsymlinks:nativestrict
	DISPLAY=localhost:0
elif [[ $_uname == Darwin ]]; then
	PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
	INFOPATH="/usr/local/opt/coreutils/share/info:$INFOPATH"
	export BASH_COMPLETION_COMPAT_DIR=/usr/local/etc/bash_completion.d
	export BASH_COMPLETION_DIR=/usr/local/share/bash-completion
elif [[ $_uname == WSL ]]; then
	DISPLAY=localhost:0
	LC_CTYPE=en_US.UTF-8
fi

printf "\e]12;#00ffff\a"
printf "\e[2 q"

export LS_COLORS='rs=0:di=01;34:ln=01;04;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:'

[[ -r ~/.opam/opam-init/init.sh ]] && . ~/.opam/opam-init/init.sh
[[ -r ~/.bashrc ]] && . ~/.bashrc
[[ -r ~/.localbash_profile.sh ]] && . ~/.localbash_profile.sh
true
