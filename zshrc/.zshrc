eval "$(starship init zsh)"

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history


# Zsh plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-bat/zsh-bat.zsh
source ~/.config/zsh/zsh-vi-mode/zsh-vi-mode.zsh

# fzf
source <(fzf --zsh)

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
