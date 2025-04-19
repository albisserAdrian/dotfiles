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
    if ! sudo apt update || ! sudo apt install -y zsh; then
      echo "Failed to install zsh."
      exit 1
    fi
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    echo "Installing zsh on Arch..."
    if ! sudo pacman -Syu --noconfirm zsh; then
      echo "Failed to install zsh."
      exit 1
    fi
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "Installing zsh on macOS..."
    if ! brew install zsh; then
      echo "Failed to install zsh."
      exit 1
    fi
  fi
  if ! chsh -s "$(which zsh)"; then
    echo "Failed to change default shell to zsh."
    exit 1
  fi
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

# Install
echo "Installing..."
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  sudo apt install -y curl ca-certificate unzip fzf bat stow luarocks ripgrep fd-find
elif [[ "$(uname -a)" == *"ARCH"* ]]; then
  sudo pacman -Syu --noconfirm curl ca-certificate unzip fzf bat stow luarocks ripgrep fd-find
elif [[ "$(uname)" == "Darwin" ]]; then
  brew install curl ca-certificate unzip fzf bat stow luarocks ripgrep fd-find
fi

# Install docker
if ! command -v docker &>/dev/null; then
  echo "Installing docker..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    if [[ -f /etc/os-release ]]; then
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    else
      echo "Error: /etc/os-release not found."
      exit 1
    fi
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -S docker
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install docker
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
    EZA_VERSION=$(curl -s "https://api.github.com/repos/eza-community/eza/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -fsSL "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz" | tar -xz -C /tmp
    sudo mv /tmp/eza /usr/local/bin/eza
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm eza
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install eza
  fi
fi

# Install lazygit and lazydocker
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit and lazydocker..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm lazygit
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install lazygit lazydocker
  fi
fi

# Install neovim
if ! command -v nvim &>/dev/null; then
  echo "Installing neovim..."
  if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  elif [[ "$(uname -a)" == *"ARCH"* ]]; then
    sudo pacman -Syu --noconfirm neovim
  elif [[ "$(uname)" == "Darwin" ]]; then
    brew install neovim
  fi
fi

if ! command -v cargo &>/dev/null; then
  echo "Installing rust and cargo..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  cargo install ast-grep --locked
fi

# Install fnm
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  export PATH="$HOME/.fnm:$PATH"
  eval "$(fnm env)"
fi

# Install starship
if ! command -v starship &>/dev/null; then
  echo "Installing starship..."
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

# Clone dotfiles and use stow
DOTFILES_DIR="$HOME/dev/environment/"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles repository..."
  mkdir -p "$HOME/dev/environment/"
  git clone https://github.com/albisserAdrian/dotfiles.git "$DOTFILES_DIR"
fi

echo "Using stow to symlink configurations..."
cd "$DOTFILES_DIR" || exit 1
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
