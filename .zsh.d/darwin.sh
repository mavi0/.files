#!/usr/bin/env bash

function 1password_ssh_agent() {
  local agentpath="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  local agentlinkpath="${1}"
  if [[ ! -e "${agentlinkpath}" ]]; then
    if [[ -e "${agentpath}" ]]; then
      mkdir -p "$(dirname "$agentlinkpath")"
      ln -s "${agentpath}" "${agentlinkpath}"
    fi
  fi
  if [[ -e "${agentlinkpath}" ]]; then
    export SSH_AUTH_SOCK="${agentlinkpath}"
  fi
}

# Homebrew Configuration
export HOMEBREW_NO_ANALYTICS=1
if assert_commad "bat"; then
  export HOMEBREW_BAT=1
fi
if assert_commad "brew"; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# 1Password SSH Agent Configuration
1password_ssh_agent "${HOME}/.1password/agent.sock"
unset -f 1password_ssh_agent
