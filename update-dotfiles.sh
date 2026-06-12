#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dotfiles push to repo
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📕

# Documentation:
# @raycast.author Paulius Giniūnas

DOTFILES_DIR="$HOME/.dotfiles"

cd "$HOME/.dotfiles" || exit 1

if [[ ! -d ".git" ]]; then
  echo "Error: no git repo in $DOTFILES_DIR"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  git add .
  git commit -m "update"
  git push
fi