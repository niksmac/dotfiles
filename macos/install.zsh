#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
# osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Sketch
# ==============

#Export Compact SVGs
defaults write com.bohemiancoding.sketch3 exportCompactSVG -bool yes


# System
# ==============

# Set Wallpaper
sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '~/.dotfiles/osx/study-hard.png'" && killall Dock

# Set Login Window Text
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "Tweet me @niksmac_"


# Safari
# ==============

#Enable Develop Menu and Web Inspector
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

# TextEdit
# ==============

# Use Plain Text Mode as Default

defaults write com.apple.TextEdit RichText -int 0



# Xcode
# ==============

# Install Command Line Tools without Xcode
xcode-select --install

# Remove All Unavailable Simulators
xcrun simctl delete unavailable


# Finder
# ==============

# Show All File Extensions
defaults write -g AppleShowAllExtensions -bool true

# Adjust Number of Recent Places to 5
defaults write -g NSNavRecentPlacesLimit -int 5 && \
killall Finder

# Sets default save target to be a local disk, not iCloud.
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

#Set Current Folder as Default Search Scope
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Set Sidebar Icon Size to 'medium'.
defaults write -g NSTableViewDefaultSizeMode -int 2

# Avoids creation of .DS_Store and AppleDouble files.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


# Keyboard
# ==============

# Auto-Correct Enable (Default)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool true
