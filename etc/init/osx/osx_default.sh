#!/bin/sh

#
# Global
#

# 通常スリープ(Safe Sleepは使わない)
sudo pmset -a hibernatemode 0

# 起動音を小さく
sudo nvram SystemAudioVolume=%05

# フルキーボードアクセスを有効
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Fuキーを標準のファンクションキーとして使用
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# キーのリピート
defaults write NSGlobalDomain KeyRepeat -int 2

# リピート入力認識までの時間
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# サイドバーのアイコンサイズを大きく
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true


#
# Menubar
#

# バッテリー残量を％表記に
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# 日付と時刻のフォーマット（24時間表示、秒表示あり、日付・曜日を表示）
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"


#
# Dock
#

# 通常サイズ
defaults write com.apple.dock tilesize -int 32

# 拡大を有効にする
defaults write com.apple.dock magnification -bool yes

# 拡大時のサイズ (一般的な最大: 128)
defaults write com.apple.dock largesize -int 128

# Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true

# Dockをすぐに表示する
defaults write com.apple.dock autohide-delay -float 0

# 設定反映
killall Dock


#
# Dashboard
#

# Dashboardを無効にする
defaults write com.apple.dashboard mcx-disabled -bool true


#
# Finder
#

# デフォルトはカラムビュー表示
defaults write com.apple.finder FXPreferredViewStyle clmv

# デスクトップ上にアイコンを表示しない
defaults write com.apple.finder CreateDesktop -boolean false

# タイトルバーにフルパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# 他のウィンドウに移った時にQuick Lookを非表示する
defaults write com.apple.finder QLHidePanelOnDeactivate -bool true

# Quick Look上でテキストの選択を可能に
defaults write com.apple.finder QLEnableTextSelection -bool true

# 「ライブラリ」を常に表示
chflags nohidden ~/Library

# Finder再起動して設定を反映
killall Finder


#
# System
#

# ネットワークフォルダに.DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


#
# Security
#

# スリープ/スクリーンセーバー解除時にパスワードを要求
defaults write com.apple.screensaver askForPassword -int 1

# 開始後5秒後からパスワードを要求
defaults write com.apple.screensaver askForPasswordDelay -int 5


#
# Trackpad
#

# タップでクリック
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true


#
# Screen Capture
#

# キャプチャの保存場所を変更
defaults write com.apple.screencapture location ~/Pictures

# キャプチャのプレフィックスを変更
defaults write com.apple.screencapture name "SS_"

# キャプチャに影を付けない
defaults write com.apple.screencapture disable-shadow -boolean true

# 設定を反映
killall SystemUIServer


#
# Preview
#

# 起動時に前回開いたウィンドウを開かない
defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false

#
# QuickTime
#

# 起動時に前回開いたファイルを開かない
defaults write com.apple.QuickTimePlayerX NSQuitAlwaysKeepsWindows -bool false
