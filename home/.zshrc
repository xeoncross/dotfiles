# Homebrew on PATH (brew, node, go, starship, nvim, ...)
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew ]] && eval "$($brew shellenv)" && break
done
typeset -U path
path=("$HOME/go/bin" $path) # `go install` binaries

export EDITOR=nvim

autoload -U compinit && compinit

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

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

(( $+commands[starship] )) && eval "$(starship init zsh)"

# ghost text from history, ctrl-f accepts
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null &&
  bindkey '^f' autosuggest-accept
# commands turn green when valid; must be sourced last
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
