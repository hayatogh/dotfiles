if [[ -z ${TMUX:-} && -z ${SUDO_USER:-} ]] && ! tmux ls &>/dev/null; then
	tm
fi
