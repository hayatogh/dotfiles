#!/usr/bin/env bash
set -euo pipefail

# xcode-select --install

dotfiles=$(cd $(dirname $0); pwd -P)
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
if ! grep '/usr/local/bin/bash' /etc/shells &>/dev/null; then
	sudo sh -c "echo /usr/local/bin/bash >>/etc/shells"
fi
if ! type brew &>/dev/null; then
	/bin/bash -c "$(curl -fsS https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install bash bash-completion@2 chezscheme coreutils fd fzf git p7zip ripgrep rlwrap screen tree vim wget
# automake binutils diffutils ed file-formula findutils gawk gnu-indent gnu-sed gnu-tar gpatch grep gzip less make openssh rsync svn texinfo universal-ctags unzip watch wdiff zsh
# docker docker-compose docker-machine

brew install --cask iterm2 xquartz karabiner-elements discretescroll scroll-reverser macs-fan-control alt-tab middleclick drawio slack zotero
brew install --cask virtualbox virtualbox-extension-pack vagrant
# mactex-no-gui
# racket

# defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0 # not working
# defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false # not working
# defaults write -g NSScrollAnimationEnabled -bool false # not working
# defaults write -g NSScrollViewRubberbanding -bool false # not working
# defaults write -g NSToolbarFullScreenAnimationDuration -float 0 # not working
defaults write -g NSWindowResizeTime -float 0.001 # double click title bar
# defaults write -g QLPanelAnimationDuration -float 0 # not working
# defaults write com.apple.finder DisableAllAnimations -bool true # not working
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false # new window zoom effect
defaults write -g NSTextInsertionPointBlinkPeriodOff -float 0.00001 # cursor
defaults write -g NSTextInsertionPointBlinkPeriodOn -float 1e38 # cursor
defaults write -g com.apple.mouse.scaling -integer -1 # mouse acceleration
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.dock autohide-delay -float 0 # deley before appear
defaults write com.apple.dock autohide-time-modifier -float 0 # autohide speed
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock springboard-hide-duration -float 0
defaults write com.apple.dock springboard-page-duration -float 0
defaults write com.apple.dock springboard-show-duration -float 0

defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -string "20.0"
