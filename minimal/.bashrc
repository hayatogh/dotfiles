export CRASHPAGER='/usr/bin/less -FX'
export LESS=-RiWM
export VISUAL=vim
export PROMPT_COMMAND='history -a; history -c; history -r'
export PS1='\[\e[0m\]\n\[\e[32m\]\u@\h \[\e[33m\]\w \[\e[38;5;166m\]$([[ \j -gt 0 ]] && echo \j)\[\e[0m\] \[\e[38;5;245m\]${PIPESTATUS[@]}\[\e[0m\]\n\[\ek\e\\\]\$ '
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=2000
export HISTTIMEFORMAT='%c : '

[[ ! $- =~ i ]] && return
shopt -s autocd cdspell checkhash checkjobs checkwinsize dotglob execfail globstar lithist no_empty_cmd_completion nocaseglob
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias iconv_cp932='iconv -f cp932'
alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -lhF'
alias al='ls -alhF'
alias rm='rm -i'
alias sr='screen -DR'
alias tm='tmux new -ADX'
# older tmux
# alias tm='tmux new -ADs0'
alias vi='vim --clean'
_regex_rubout() {
	local right=${READLINE_LINE:$READLINE_POINT}
	local left=${READLINE_LINE::$READLINE_POINT}
	[[ $left =~ $1 ]]
	left=${left::-${#BASH_REMATCH[0]}}
	READLINE_LINE=$left$right
	READLINE_POINT=${#left}
}
_cw() {
	_regex_rubout '([a-zA-Z0-9_]+|[^ a-zA-Z0-9_]+) *$'
}
bind -x '"\C-w": _cw'

printf '\e]12;#ff00ff\a'
printf '\e[2 q'
true
