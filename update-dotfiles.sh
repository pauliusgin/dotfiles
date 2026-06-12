#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"

if [[ "$(pwd)" != "$DOTFILES_DIR" ]]; then
  echo "Error: not in $DOTFILES_DIR"
  exit 1
fi

if [[ ! -d ".git" ]]; then
  echo "Error: no git repo in $DOTFILES_DIR"
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  git add .
  git commit -m "update"
  git push
fi