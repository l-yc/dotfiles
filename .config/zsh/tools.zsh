# Tool initialization (completions, version managers, language toolchains)

source <(kitty + complete setup zsh)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lyc/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lyc/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/lyc/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/lyc/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/lyc/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/home/lyc/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

mamba activate base

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opam configuration
[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
