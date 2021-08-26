#!/usr/bin/env bash
set -euo pipefail

# xcode-select --install

dotfiles=$(cd $(dirname $0); pwd -P)
sudo sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
if ! grep '/usr/local/bin/bash' /etc/shells &>/dev/null; then
	sudo sh -c "echo /usr/local/bin/bash >>/etc/shells"
fi
if ! type brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install automake bash binutils coreutils diffutils ed findutils gawk grep gzip gnu-indent less make gpatch screen gnu-sed gnu-tar texinfo wdiff wget
brew install bash-completion@2 fd file-formula fzf git openssh p7zip ripgrep rlwrap vim watch
brew install python chezscheme
# brew install rsync svn unzip zsh

brew install --cask iterm2 xquartz karabiner-elements google-japanese-ime discretescroll scroll-reverser macs-fan-control alt-tab middleclick
brew install --cask virtualbox virtualbox-extension-pack vagrant
# brew install --cask mactex-no-gui
brew install --cask drawio slack zotero
# brew install --cask hammerspoon racket osxfuse

brew install --HEAD universal-ctags/universal-ctags/universal-ctags
# brew install docker docker-compose docker-machine

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

# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/dotfiles/hammerspoon/init.lua"

cd $dotfiles
