#!/usr/bin/env zsh

## REQUIRES functions/functions.all.sh

## Configure Plugins
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

## Krypton GPG
if assert_commad "kr" "-q"; then
  export GPG_TTY=$(tty)
fi

## Zoxide CD Alternative
if assert_commad "zoxide" "-q"; then
  eval "$(zoxide init zsh)"
fi

## Starship Prompt
if assert_commad "starship" "-q"; then
  if [[ -f "${HOME}/.starship/config.toml" ]]; then
    export STARSHIP_CONFIG="${HOME}/.starship/config.toml"
  fi
  export STARSHIP_CACHE="${HOME}/.starship.cache.d"
  export STARSHIP_LOG=error
  eval "$(starship init zsh)"
fi

## FastFetch (like neofetch)
if assert_commad "fastfetch" "-q"; then 
  fastfetch --structure Title:Separator:OS:Host:Uptime:Shell:Terminal:CPUUsage:Memory:Battery:PowerAdapter:Player:Media:LocalIP
fi