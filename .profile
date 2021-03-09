# .profile
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
export LESS=-RiWM
export VISUAL=vim
export EDITOR=vim
export SCREENDIR="$HOME/.screen"
export LYNX_CFG="$HOME/dotfiles/lynx.cfg"
export CHKTEXRC="$HOME/dotfiles/chktexrc"
export RUST_BACKTRACE=1
export MYPY_CACHE_DIR="$HOME/.cache/mypy"
export RIPGREP_CONFIG_PATH="$HOME/dotfiles/.ripgreprc"
export XDG_CONFIG_HOME="$HOME/.config"
export RLWRAP_HOME="$HOME/.config/rlwrap"
