#!/usr/bin/env zsh

# Spicetify - A spotify client customization tool
if ! command -v "spicetify" > /dev/null 2>&1; then
  export PATH="$PATH:${HOME}/.spicetify"
fi
