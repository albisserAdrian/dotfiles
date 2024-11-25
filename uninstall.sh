#!/bin/bash

# Determine the shell in use
if [[ "$SHELL" == *"zsh"* ]]; then
  SHELL_RC="$HOME/.zshrc"
  SHELL_NAME="zsh"
elif [[ "$SHELL" == *"bash"* ]]; then
  SHELL_RC="$HOME/.bashrc"
  SHELL_NAME="bash"
else
  echo "Unsupported shell. This script only works with bash or zsh."
  exit 1
fi

# Uninstall oh-my-zsh
if [[ "$SHELL_NAME" == "zsh" && -d "$HOME/.oh-my-zsh" ]]; then
  echo "Uninstalling oh-my-zsh..."
  rm -rf "$HOME/.oh-my-zsh"
fi

# Remove spaceship prompt theme
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Removing spaceship prompt theme..."
  rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
fi

# Remove neovim
if command -v neovim &> /dev/null; then
  echo "Removing neovim..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt remove -y neovim
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew uninstall neovim
  fi
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim
fi

# Remove eza
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  echo "Removing eza on Ubuntu..."
  sudo rm -f /usr/local/bin/eza
elif [[ "$(uname)" == "Darwin" ]]; then
  echo "Removing eza on MacOS..."
  brew uninstall eza
fi

# Remove fnm
if command -v fnm &> /dev/null; then
  echo "Removing fnm..."
  rm -rf "$HOME/.fnm"
fi

# Remove tmux
if command -v tmux &> /dev/null; then
  echo "Removing tmux..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt-get remove -y tmux
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew uninstall tmux
  fi
  # Remove tmux configuration
  rm -rf ~/.config/tmux
fi

# Remove bat
if command -v bat &> /dev/null; then
  echo "Removing bat..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt-get remove -y bat
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew uninstall bat
  fi
fi

# Remove zsh plugins
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Removing zsh plugins..."
  ZSH_CUSTOM="${ZSH:-$HOME/.oh-my-zsh}/custom"
  rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
  rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat
fi

# Remove .zshrc
if [[ "$SHELL_NAME" == "zsh" && -f "$HOME/.zshrc" ]]; then
  echo "Removing .zshrc..."
  rm -f "$HOME/.zshrc"
fi

# Finish up
echo "Uninstallation complete. Please restart your terminal to apply the changes."
