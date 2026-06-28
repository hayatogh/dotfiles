export LIBVIRT_DEFAULT_URI=qemu:///system
alias drive='rclone mount drive: ~/Drive --vfs-cache-mode full -vv'
if [[ -z ${TMUX:-} && -z ${SUDO_USER:-} && -z $(tmux lsc 2>/dev/null) ]]; then
	tmux new -A
fi
