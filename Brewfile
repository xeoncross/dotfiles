# Every Homebrew package on this machine. scripts/homebrew.sh zaps anything
# not listed here, so install things by adding them to this file.

tap "youssofal/mtplx"
tap "oleksandrchekhovskyi/hax"

# GenAI
brew "herdr"                 # tmux for agents
brew "llmfit"                # your hardware, every local model, ranked
brew "youssofal/mtplx/mtplx" # fastest way to run Qwen models on macOs
brew "oleksandrchekhovskyi/hax/hax" # lighest agent harness I've found

brew "gh"              # GitHub CLI
brew "ca-certificates" # required for node
brew "node"
brew "go"
brew "uv"              # Python: https://github.com/astral-sh/uv
brew "python@3.13"

# Common shell / systems tools
brew "wget"
brew "curl"
brew "cloc" # lines of code and other metadata for a repo
brew "ncdu" # disk space usage cli scanner
brew "jq"   # json parsing
brew "ffmpeg"

# cli i use constantly
brew "ripgrep"   # fast search
brew "fd"        # fast find
brew "fzf"       # fuzzy finder
brew "lazygit"
brew "neovim"
brew "treehouse" # worktree manager: https://github.com/kunchenguid/treehouse

# zsh
brew "zsh-autosuggestions"     # ghost text from history
brew "zsh-syntax-highlighting" # commands turn green when valid
brew "starship"                # prompt

cask "wezterm" # replaces zsh as our terminal of choice
cask "claude-code@latest"
cask "lm-studio"    # run local models
cask "sublime-text" # default text editor
cask "rectangle"    # window management
cask "handy"        # local speech-to-text using Whisper or Parakeet models
cask "stats"        # CPU / Memory / swap usage while runing local models
cask "google-chrome"

# the font everything renders in
cask "font-hack-nerd-font"

# VSCode + extensions
cask "visual-studio-code"
vscode "golang.go"                           # Go language support
vscode "rust-lang.rust-analyzer"             # Rust language server
vscode "ms-python.vscode-pylance"            # Python language server
vscode "saoudrizwan.claude-dev"              # Cline for local agents
vscode "shd101wyy.markdown-preview-enhanced"
vscode "jnoortheen.nix-ide"                  # nix language server
vscode "humao.rest-client"                   # http client inside vscode
