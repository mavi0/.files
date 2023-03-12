#!/usr/bin/env zsh

# Standard
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"

# Replace `ls` with `exa` for nicer formatting with icons and colors...
alias ls="run_alternative ls exa https://github.com/ogham/exa -lah"
alias lsl="run_alternative ls exa https://github.com/ogham/exa -l"
alias lsa="run_alternative ls exa https://github.com/ogham/exa -a"
alias lsla="run_alternative ls exa https://github.com/ogham/exa -a -l"

# Replace 'cat' with 'bat' for nicer formatting with colors, line numbers etc...
alias cat="run_alternative cat bat https://github.com/sharkdp/bat"

# Replace 'htop' and 'gotop' with 'btm' for nicer graph output...
alias htop="run_alternative htop btm https://github.com/ClementTsang/bottom"
alias gotop="run_alternative gotop btm https://github.com/ClementTsang/bottom"

# Terminal utility shortcuts:
alias weather='curl http://v2.wttr.in/"${WEATHER_CITY}"'

# Duck Duck Gor Shortuts
if [ -x "$(command -v ddgr)" ]; then
  alias ddg="ddgr --reg en-gb --unsafe --noprompt"
  alias ddgp="ddgr --reg en-gb --unsafe"
fi

# Docker Shortcuts
if [ -x "$(command -v docker)" ]; then
  alias dalpine='docker run --rm -it -v "$(pwd)":/shared alpine:latest'
  alias dubuntu='docker run --rm -it -v "$(pwd)":/shared ubuntu:latest'
  alias dnginx='docker run --rm -it -v "$(pwd)":/usr/share/nginx/html:ro -p 8080:80 nginx'
fi
