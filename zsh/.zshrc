export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"

alias python3="/opt/homebrew/bin/python3.12"
alias pip3="/opt/homebrew/bin/pip3.12"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Added by Antigravity
export PATH="/Users/jorgeantonio/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Claude Code in yolo mode
alias claude-yolo="claude --dangerously-skip-permissions"

# Oh my Posh themes
eval "$(oh-my-posh init zsh --config ~/themes.json)"
export TERM=xterm-256color

# Zsh auto-suggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# opencode
export PATH=/Users/jorgeantonio/.opencode/bin:$PATH
