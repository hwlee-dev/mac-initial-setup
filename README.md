# 맥북 초기 설정

- Dock 구분 추가
- oh-my-zsh 설치
- zsh auto suggestion 설치
- Homebrew 설치
- .zshrc 설정
  - Homebrew
  - nvm
- Brewfile 생성
- Brewfile 설치
- nvm 설치
- node 최신 버전 설치

```
cd ~
chmod +x mac-initial-setup.sh

# 개인용
./mac-initial-setup --personal

# 업무용
./mac-initial-setup
```

### Mac Dock 구분선 추가
```shell
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}';
```

### YT-DLP 명령어
```shell
yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 <URL>
```