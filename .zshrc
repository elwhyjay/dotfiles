# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────
# Zsh core settings
# ─────────────────────────────────────────────

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Key bindings (emacs style)
bindkey -e

# ─────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────

if [ -d "/opt/homebrew/bin" ] ; then
    export PATH="/opt/homebrew/bin:$PATH"
fi
if [ -d "/usr/local/bin" ] ; then
    export PATH="/usr/local/bin:$PATH"
fi

# LLVM
if [ -d "/usr/local/opt/llvm/bin" ] ; then
    export PATH="/usr/local/opt/llvm/bin:$PATH"
elif [ -d "/opt/homebrew/opt/llvm/bin" ] ; then
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
elif [ -d "/usr/lib/llvm/bin" ] ; then
    export PATH="/usr/lib/llvm/bin:$PATH"
fi

# Zig
if [ -d "/usr/local/bin/zig" ] ; then
    export PATH="/usr/local/bin/zig:$PATH"
elif [ -d "/opt/homebrew/bin/zig" ] ; then
    export PATH="/opt/homebrew/bin/zig:$PATH"
fi

# Go
export GOPATH="${HOME}/.go"
export GOROOT=/usr/local/go
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# WezTerm
if [ -d "/Applications/WezTerm.app/Contents/MacOS" ] ; then
    export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
fi

# ─────────────────────────────────────────────
# Powerlevel10k
# ─────────────────────────────────────────────

if [ -f "/opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f "$HOME/.powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
elif [ -f "/usr/share/powerlevel10k/powerlevel10k.zsh-theme" ]; then
    source /usr/share/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ─────────────────────────────────────────────
# Tools
# ─────────────────────────────────────────────

# Conda
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# mise
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# Lium CLI completion
command -v lium >/dev/null 2>&1 && eval "$(_LIUM_COMPLETE=zsh_source lium)"

# ─────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────

alias vim="nvim"
alias ls="lsd"
alias tmux="TERM=xterm-256color tmux"
alias svim='sudo nvim -u ~/dotfiles/.vimrc'

# zsh-syntax-highlighting (keep near end of .zshrc)
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
