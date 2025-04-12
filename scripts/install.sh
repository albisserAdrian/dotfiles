#!/bin/bash

# Determine the shell in use
if [[ "$SHELL" == *"zsh"* ]]; then
  SHELL_RC="$HOME/.zshrc"
  SHELL_NAME="zsh"
elif [[ "$SHELL" == *"bash"* ]]; then
  SHELL_RC="$HOME/.bashrc"
  SHELL_NAME="bash"
  # Install zsh if bash is the default shell and we're on an Ubuntu system
  if [[ "$(uname -a)" $$ *"Ubuntu"* ]]; then
    echo "Installing zsh..."
    sudo apt update && sudo apt install -y zsh || {
      echo "Failed to install zsh."
      exit 1
    }
    # Change default shell to zsh
    chsh -s $(which zsh) || {
      echo "Failed to change default shell to zsh."
      exit 1
    }
    SHELL_RC="$HOME/.zshrc"
    SHELL_NAME="zsh"
  fi
else
  echo "Unsupported shell. This script only works with bash or zsh."
  exit 1
fi

# Install Homebrew if on MacOS
if [[ "$SHELL_NAME" == "zsh" && "$(uname)" == "Darwin" ]]; then
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
      echo "Failed to install Homebrew."
      exit 1
    }
    export PATH="/opt/homebrew/bin:$PATH"
  fi
fi

# TODO: Install latest bash on mac

# Install tmux
if ! command -v tmux &>/dev/null; then
  echo "Installing tmux..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y tmux
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install tmux
  fi
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install fzf
if ! command -v tmux &>/dev/null; then
  echo "Installing tmux..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y tmux
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install fzf
  fi
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install eza
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  echo "Installing eza on Ubuntu..."
  sudo apt install -y curl unzip
  curl -fsSL https://github.com/eza-community/eza/releases/download/v0.11.1/eza-v0.11.1-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /tmp
  sudo mv /tmp/eza /usr/local/bin/eza
elif [[ "$(uname)" == "Darwin" ]]; then
  echo "Installing eza on MacOS..."
  brew install eza
fi

# Install bat
if ! command -v bat &>/dev/null; then
  echo "Installing bat..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y bat
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install bat
  fi
fi

# Install fnm
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.fnm:$PATH"
  eval "$(fnm env)"
fi

# Install starship
if ! command -v fzf &>/dev/null; then 
  echo "Installing fzf..."
  curl -sS https://starship.rs/install.sh | sh
fi

# Install plugins
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Installing zsh plugins..."

  # Clone necessary plugin repositories
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/zsh-syntax-highlighting
  git clone https://github.com/fdellwing/zsh-bat.git ~/.config/zsh/zsh-bat
  git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.config/zsh/zsh-vi-mode
fi

# Finish up
echo "Configuration complete. Please restart your terminal or run 'source $SHELL_RC' to apply the changes."
