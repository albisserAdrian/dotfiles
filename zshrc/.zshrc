eval "$(starship init zsh)"

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history

# Zsh plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-bat/zsh-bat.plugin.zsh
source ~/.config/zsh/zsh-vi-mode/zsh-vi-mode.zsh

# fzf
source <(fzf --zsh)

# fnm MacOS
FNM_PATH="$HOME/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(fnm env --use-on-cd --shell zsh)"

# Git aliases
alias ga="git add"
alias gst="git status"
alias gc="git commit"
alias gch="git checkout"
alias gp="git push"
alias gl="git pull"
alias gb="git branch"

# Eza aliases
alias ll="eza -l --icons"
alias la="eza -la --icons"
alias lr="eza -lR --icons"
alias lra="eza -laR --icons"
alias lt="eza -lT --icons --no-user --no-time --no-permissions --no-filesize"
alias lta="eza -laT --icons --no-user --no-time --no-permissions --no-filesize"
alias ls="eza --icons"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
