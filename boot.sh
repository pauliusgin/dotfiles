#!/bin/zsh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
ln -swf $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $HOME/.dotfiles/Brewfile

# Create directories
mkdir $HOME/Documents/Books
mkdir $HOME/Documents/Learn\ To\ Code
mkdir $HOME/Documents/Personal
mkdir $HOME/Work
mkdir $HOME/Pictures/Wallpapers
mkdir $HOME/.config
mkdir $HOME/.config/nvim
mkdir $HOME/.config/kitty
mkdir $HOME/.vscode
mkdir $HOME/.vscode/extensions


# Symlinks
ln -swf $HOME/.dotfiles/.zshrc $HOME/.zshrc
ln -swf $HOME/.dotfiles/kitty.conf $HOME/.config/kitty/kitty.conf
ln -swf $HOME/.dotfiles/init.lua $HOME/.config/nvim/init.lua
ln -swf $HOME/.dotfiles/.gitconfig $HOME/.gitconfig
ln -swf $HOME/.dotfiles/code/extensions.json $HOME/.vscode/extensions/extensions.json
ln -swf $HOME/.dotfiles/.cspell.json $HOME/.cspell.json

#Npm packs
npm i -g cspell @cspell/dict-lt-lt @cspell/dict-lua eslint prettier typescript typescript-language-server ts-node

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/mac/.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences - we will run this last because this will reload the shell
source $HOME/.dotfiles/mac/.macos