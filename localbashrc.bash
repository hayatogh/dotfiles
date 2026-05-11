if [[ -z ${TMUX:-} && -z ${SUDO_USER:-} && -z $(tmux lsc 2>/dev/null) ]]; then
	tmux new -A
fi
