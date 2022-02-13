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

# Export Compact SVGs
defaults write com.bohemiancoding.sketch3 exportCompactSVG -bool yes


# System
# ==============

# Play iOS charging sound when MagSafe is connected.
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true && \
open /System/Library/CoreServices/PowerChime.app


# Mail
# ===============
# Show Attachments as Icons

defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Safari
# ==============

#Enable Develop Menu and Web Inspector
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true

# Disable hyperlink auditing beacon

defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2HyperlinkAuditingEnabled -bool false

defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2HyperlinkAuditingEnabled -bool false

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# TextEdit
# ==============

# Use Plain Text Mode as Default
defaults write com.apple.TextEdit RichText -int 0


# Finder
# ==============

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show All File Extensions
defaults write -g AppleShowAllExtensions -bool true

# Adjust Number of Recent Places to 5
defaults write -g NSNavRecentPlacesLimit -int 5

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

# Hide all desktop icons because who need 'em'
defaults write com.apple.finder CreateDesktop -bool false

# Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show Full Path in Finder Title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keyboard
# ==============

# Auto-Correct Enable (Default)
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool true

# Enable Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Sets a very fast repeat rate, adjust to taste.
defaults write -g InitialKeyRepeat -int 13 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 3 # normal minimum is 2 (30 ms)

# Terminal & iTerm 2
# ==============

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false


# Dock
# ==============

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Set icon size
defaults write com.apple.dock tilesize -int 45

# Lock the Dock Size
defaults write com.apple.Dock size-immutable -bool yes && killall Dock


# Misc
# ==============

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Screenshots into a specfic folder
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots

# Disable crsh reporter
defaults write com.apple.CrashReporter DialogType none

# Rubberband Scrolling
defaults write -g NSScrollViewRubberbanding -bool true


# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true


# Transmission.app                                                            #

# Use `~/Documents/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don’t prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true


## Auto pull repo and update weekly...
# sudo crontab -u "$(whoami)" -e
# sudo echo '30 3 * * 0 update-dot > /dev/null 2>&1' >> /etc/crontab
# sudo echo '30 3 * * 0 brewit > /dev/null 2>&1' >> /etc/crontab

## Set app icons

# set vscode icon
yes | cp ./icons/vscode.icns /Applications/Visual\ Studio\ Code.app/Contents/Resources/Code.icns

# set app-cleaner icon
yes | cp ./icons/app-cleaner.icns /Applications/AppCleaner.app/Contents/Resources/AppCleaner.icns

# set telegram icon
yes | cp ./icons/telegram.icns /Applications/Telegram.app/Contents/Resources/AppIcon.icns
touch /Applications/Telegram.app

killall Dock

killall Finder
