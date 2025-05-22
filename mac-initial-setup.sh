#!/bin/bash

# Dock 구분 추가
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
killall Dock

# oh-my-zsh 설치
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh auto suggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i '' 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc

# Homebrew 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# .zshrc 설정
######################################################################
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# Homebrew
if ! grep -Fxq "export PATH=/opt/homebrew/bin:\$PATH" ~/.zshrc; then
    echo "export PATH=/opt/homebrew/bin:\$PATH" >> ~/.zshrc
    echo ".zshrc updated with PATH"
else
    echo "PATH already set in .zshrc"
fi

# nvm
if ! grep -Fxq 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc; then
    # Add the NVM lines to .zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
    echo "NVM configuration added to .zshrc."
else
    echo "NVM configuration already exists in .zshrc."
fi

source ~/.zshrc
######################################################################

# Brewfile 생성
######################################################################
Brewfile_path=~/Brewfile

if [ ! -f "$Brewfile_path" ]; then
    touch "$Brewfile_path"
fi

cat <<EOL > "$Brewfile_path"
# Mac App Store command-line interface
brew "git"
brew "mas"
brew "yarn"

# Youtube 다운로더 - 개인 사용
# brew "ffmpeg"
# brew "yt-dlp"

# 도구
cask "alfred"
cask "karabiner-elements"
cask "macupdater"
cask "rectangle"
cask "soundsource"

# 일반 프로그램
cask "adobe-acrobat-reader"
cask "google-chrome"
cask "iina"
cask "notion"
cask "slack"
cask "telegram"

# 개발
cask "jetbrains-toolbox"

# mas
mas "카카오톡", id: 869223134
EOL

echo "Brewfile created and populated."
######################################################################

# Brewfile 설치
brew bundle

# nvm 설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# node 최신 버전 설치
nvm install node