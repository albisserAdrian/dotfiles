#!/bin/bash

# Determine the shell in use
if [[ "$SHELL" == *"zsh"* ]]; then
  SHELL_RC="$HOME/.zshrc"
  SHELL_NAME="zsh"
elif [[ "$SHELL" == *"bash"* ]]; then
  SHELL_RC="$HOME/.bashrc"
  SHELL_NAME="bash"
  # Install zsh if bash is the default shell and we're on an Ubuntu system
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
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
  if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
      echo "Failed to install Homebrew."
      exit 1
    }
    export PATH="/opt/homebrew/bin:$PATH"
  fi
fi

# Install oh-my-zsh if using zsh and it is not installed
if [[ "$SHELL_NAME" == "zsh" && ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
    echo "Failed to install oh-my-zsh."
    exit 1
  }
fi

# Install spaceship prompt theme
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Installing spaceship prompt theme..."
  ZSH_CUSTOM="${ZSH:-$HOME/.oh-my-zsh}/custom"
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
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

# Install fnm
if ! command -v fnm &> /dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.fnm:$PATH"
  eval "$(fnm env)"
fi

# Install tmux
if ! command -v tmux &> /dev/null; then
  echo "Installing tmux..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y tmux
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install tmux
  fi
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install bat
if ! command -v bat &> /dev/null; then
  echo "Installing bat..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y bat
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install bat
  fi
fi

# Install Neovim
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    sudo apt install -y neovim
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install neovim
  fi
  echo "Setting up LazyVim..."
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
  rm -rf ~/.cache/nvim
  git clone https://github.com/LazyVim/starter ~/.config/nvim --depth=1
  rm -rf ~/.config/nvim/.git
fi

# Update configuration file with necessary settings
echo "Configuring $SHELL_RC..."
cat <<EOF > "$SHELL_RC"

# Oh-my-zsh configuration
export ZSH="\$HOME/.oh-my-zsh"

# Zsh theme
ZSH_THEME="spaceship"

# Zsh plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
  zsh-bat
  vi-mode
)

# Source oh-my-zsh
source \$ZSH/oh-my-zsh.sh

# fnm
eval "\$(fnm env --use-on-cd --shell $SHELL_NAME)"

# Eza aliases
alias ll="eza -l --icons"
alias la="eza -la --icons"
alias lr="eza -lR --icons"
alias lra="eza -laR --icons"
alias lt="eza -lT --icons --no-user --no-time --no-permissions --no-filesize"
alias lta="eza -laT --icons --no-user --no-time --no-permissions --no-filesize"
alias ls="eza --icons"
EOF

# Install plugins
if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "Installing zsh plugins..."

  # Clone necessary plugin repositories
  ZSH_CUSTOM="${ZSH:-$HOME/.oh-my-zsh}/custom"
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_CUSTOM/plugins/you-should-use
  git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
fi

# Finish up
echo "Configuration complete. Please restart your terminal or run 'source $SHELL_RC' to apply the changes."