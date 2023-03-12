#!/usr/bin/env zsh

alias captive="open http://captive.apple.com/hotspot-detect.html"
alias set-screenshot-format="defaults write com.apple.screencapture type"
alias add-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && killall Dock"
alias add-small-dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}' && killall Dock"
