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
