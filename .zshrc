# Ensure Homebrew Python takes precedence over system/CommandLineTools Python
export PATH="/opt/homebrew/bin:$PATH"

# Claude Code aliases (replaces GitHub Copilot CLI)
alias '??'='claude'
suggest() { claude "suggest a shell command to: $*"; }

# zsh autosuggestions (accept with →)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf shell integration
source <(fzf --zsh)

# starship prompt
eval "$(starship init zsh)"

# Machine-local config (secrets, env vars not tracked by git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
