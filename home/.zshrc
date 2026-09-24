# ~/.zshrc - linked from ~/.dotfiles/home/.zshrc by scripts/links.sh

# Homebrew: puts brew, node, go, starship, nvim, etc. on PATH
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew ]] && { eval "$($brew shellenv)"; break; }
done
unset brew

# PATH: dedupe, then add `go install` binaries
typeset -U path cdpath fpath manpath
path=("$HOME/go/bin" $path)

export EDITOR=nvim

# Completion (brew's site-functions are on fpath via shellenv)
autoload -U compinit && compinit

# History (matches the old home-manager defaults)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Ghost-text suggestions from history; ctrl-f accepts
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
if [[ -r $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history)
  bindkey '^f' autosuggest-accept
fi

alias ..='cd ..'
alias add='git add .'
alias push='git push'
alias pull='git pull'
alias m='git switch main'
alias cc='claude --dangerously-skip-permissions'
alias co='codex --full-auto'
alias server='python3 -m http.server 8080'
alias cloc='cloc --vcs=git' # use .gitignore to skip non-source files
# run models all night / clamshell without letting the computer sleep
alias preventsleep='sudo pmset -b sleep 0; sudo pmset -b disablesleep 1'
alias enablesleep='sudo pmset -b sleep 30; sudo pmset -b disablesleep 0'

# Prompt
if [[ $TERM != dumb ]] && (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Commands turn green when valid. Must be sourced last.
if [[ -r $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
fi
unset BREW_PREFIX
