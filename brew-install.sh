#!/usr/bin/env bash
set -euo pipefail

dotfiles=$(realpath $(dirname $0))
sh -c "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >/etc/sudoers.d/$USER"
/usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`"

brew install coreutils less gnu-which
brew install bash bash-completion@2
brew install ed gawk gnu-sed grep
brew install binutils
brew install diffutils gpatch wdiff
brew install make automake m4
brew install findutils gzip gnu-indent gnu-tar texinfo wget
brew install screen watch
brew install file-formula
brew install git openssh
brew install python chezscheme
brew install vim
brew install rlwrap
# brew install gnutls
# brew install rsync
# brew install svn
# brew install unzip
# brew install zsh

brew install p7zip
brew install ripgrep fd
brew install fzf

brew install --cask iterm2 xquartz
brew install --cask karabiner-elements google-japanese-ime discretescroll scroll-reverser macs-fan-control
brew install --cask hammerspoon
brew install --cask virtualbox virtualbox-extension-pack vagrant
brew install --cask mactex-no-gui
brew install --cask racket
brew install --cask slack
brew install --cask drawio
brew install --cask zotero
brew install --cask osxfuse

brew install --HEAD universal-ctags/universal-ctags/universal-ctags
# brew install docker docker-compose docker-machine

defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSScrollAnimationEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g QLPanelAnimationDuration -float 0
defaults write -g NSScrollViewRubberbanding -bool false
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
defaults write -g NSToolbarFullScreenAnimationDuration -float 0
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0
defaults write com.apple.dock springboard-page-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write -g NSTextInsertionPointBlinkPeriodOn -float 1e38
defaults write -g NSTextInsertionPointBlinkPeriodOff -float 1e-45
defaults write com.apple.dock no-bouncing -bool false
defaults write -g com.apple.mouse.scaling -integer -1

defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -string "20.0"

defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/dotfiles/hammerspoon/init.lua"

xcode-select --install

cd $dotfiles
./pip3-install.sh
./install-cheat.sh

./getbashcompletion.sh
