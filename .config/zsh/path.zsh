# PATH — depends on env.zsh for GOPATH/DAFNYPATH/GEM_HOME.
# (conda, cargo, nvm, and pyenv prepend their own entries in tools.zsh.)

PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$PATH:$HOME/Android/Sdk/platform-tools"
PATH="$PATH:/var/lib/flatpak/exports/bin"
PATH="$PATH:/var/lib/snapd/snap/bin"
PATH="$PATH:$HOME/.flush/scripts"
PATH="$PATH:$HOME/.local/share/pnpm/bin"
PATH="$PATH:$GOPATH/bin"
PATH="$PATH:$DAFNYPATH"
PATH="$PATH:$HOME/.elan/bin"
PATH="$PATH:$GEM_HOME/bin"
PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH
