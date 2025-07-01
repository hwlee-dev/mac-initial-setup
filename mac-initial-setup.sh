#!/bin/bash

# 벤치마크: 스크립트를 루트 권한으로 실행할 경우를 방지
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run this script with sudo."
  exit 1
fi

# Dock 구분 추가 (sudo 필요)
sudo defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
sudo defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
sudo defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
sudo killall Dock

# Homebrew 설치 (사용자 권한으로 실행)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# .zshrc 설정
######################################################################
if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

# Homebrew PATH 추가
if ! grep -Fxq "export PATH=/opt/homebrew/bin:\$PATH" ~/.zshrc; then
    echo "export PATH=/opt/homebrew/bin:\$PATH" >> ~/.zshrc
fi

# nvm 설정 추가
if ! grep -Fxq 'export NVM_DIR="$HOME/.nvm"' ~/.zshrc; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
fi

source ~/.zshrc
######################################################################

# Brewfile 생성 및 내용 작성
######################################################################
Brewfile_path=~/Brewfile

if [ ! -f "$Brewfile_path" ]; then
    touch "$Brewfile_path"
fi

# --personal 플래그 체크
personal=0
for arg in "$@"; do
    if [ "$arg" == "--personal" ]; then
        personal=1
        break
    fi
done

# Brewfile 내용 작성
cat <<EOL > "$Brewfile_path"
# Mac App Store command-line interface
brew "git"
brew "mas"
brew "yarn"
EOL

# 개인 사용 애플리케이션 추가
if [ "$personal" -eq 1 ]; then
    cat <<EOL >> "$Brewfile_path"
brew "ffmpeg"
brew "yt-dlp"
cask "discord"
cask "telegram"
EOL
fi

cat <<EOL >> "$Brewfile_path"
# 도구
cask "aldente"
cask "alfred"
cask "bartender"
cask "karabiner-elements"
cask "macupdater"
cask "rectangle"
cask "soundsource"

# 일반
cask "adobe-acrobat-reader"
cask "google-chrome"
cask "iina"
cask "notion"
cask "slack"

# 개발
cask "figma"
cask "iterm2"
cask "jetbrains-toolbox"

# mas
mas "카카오톡", id: 869223134
EOL

echo "Brewfile created and populated."
######################################################################

# Brewfile 설치
brew bundle

# oh-my-zsh 설치
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh auto suggestion 설치
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i '' 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc

# nvm 설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# node 최신 버전 설치
nvm install node

echo "Setup complete."
