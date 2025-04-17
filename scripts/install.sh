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

# Install zsh if bash is the default shell
if [[ "$SHELL_NAME" == "bash" ]]; then
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    echo "Installing zsh on Ubuntu..."
    sudo apt update && sudo apt install -y zsh || {
      echo "Failed to install zsh."
      exit 1
    }
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    echo "Installing zsh on Arch..."
    sudo pacman -Syu --noconfirm zsh || {
      echo "Failed to install zsh."
      exit 1
    }
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "Installing zsh on macOS..."
    brew install zsh || {
      echo "Failed to install zsh."
      exit 1
    }
  fi
  chsh -s $(which zsh) || {
    echo "Failed to change default shell to zsh."
    exit 1
  }
  SHELL_RC="$HOME/.zshrc"
  SHELL_NAME="zsh"
fi

# Install Homebrew if on macOS
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

# Install tmux
if ! command -v tmux &>/dev/null; then
  echo "Installing tmux..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y tmux
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm tmux
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install tmux
  fi
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install fzf
if ! command -v fzf &>/dev/null; then
  echo "Installing fzf..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y fzf
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm fzf
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install fzf
  fi
fi

# Install eza
if ! command -v eza &>/dev/null; then
  echo "Installing eza..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y curl unzip
    curl -fsSL https://github.com/eza-community/eza/releases/download/v0.11.1/eza-v0.11.1-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /tmp
    sudo mv /tmp/eza /usr/local/bin/eza
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm eza
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install eza
  fi
fi

# Install bat
if ! command -v bat &>/dev/null; then
  echo "Installing bat..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y bat
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm bat
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

# Install stow
if ! command -v stow &>/dev/null; then
  echo "Installing stow..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y stow
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm stow
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install stow
  fi
fi

# TODO: Install lazygit lazydocker docker yay(arch)

# Install starship
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

# Install plugins
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Installing zsh plugins..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/zsh-syntax-highlighting
  git clone https://github.com/fdellwing/zsh-bat.git ~/.config/zsh/zsh-bat
  git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.config/zsh/zsh-vi-mode
fi

# Clone dotfiles and use stow
DOTFILES_DIR="$HOME/dev/projects/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles repository..."
  mkdir -p "$HOME/dev/projects"
  git clone https://github.com/albisserAdrian/dotfiles.git "$DOTFILES_DIR"
fi

echo "Using stow to symlink configurations..."
cd "$DOTFILES_DIR"
stow ghostty tmux nvim zshrc

# Install fonts
FONTS_DIR="$DOTFILES_DIR/fonts"
if [[ -d "$FONTS_DIR" ]]; then
  echo "Installing fonts..."
  if [[ "$(uname -a)" == *"Ubuntu"* || "$(uname -a)" == *"ARCH"* ]]; then
    mkdir -p ~/.local/share/fonts
    find "$FONTS_DIR" -name "*.ttf" -exec cp {} ~/.local/share/fonts/ \;
    fc-cache -fv
  elif [[ "$(uname)" == "Darwin" ]]; then
    find "$FONTS_DIR" -name "*.ttf" -exec cp {} ~/Library/Fonts/ \;
  fi
fi

# Finish up
echo "Configuration complete. Please restart your terminal or run 'source $SHELL_RC' to apply the changes."
