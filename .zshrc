# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----- oh-my-zsh -----
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ----- environment -----
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export GOPATH="$HOME/Documents/LocalDev/go"
export DAFNYPATH="$HOME/Documents/Dev/dafny-4.10"
export GEM_HOME="$HOME/gems"

export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly
export QT_AUTO_SCREEN_SCALE_FACTOR=0.5 # for qt apps like calibre to not appear huge
export LIBVIRT_DEFAULT_URI="qemu:///system" # for kvm to work properly
export GPG_TTY=$(tty)

# ----- PATH -----
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

# ----- aliases -----
alias lll='ls -al --color=auto'
alias ll='ls -alh'
alias vim='nvim'
alias vimm='nvim --cmd "let g:level=0"'
alias vimmm='nvim --cmd "let g:level=-1"'
alias emacs='emacs-nox'

alias dcode='cd "$HOME/Dropbox/Main/Code/CP"'
alias school='cd "$HOME/Dropbox/Main/School/MIT/Fall_2025"'
alias work='cd "$HOME/Dropbox/Main/Work"'
alias plv='cd "$HOME/Dropbox/Main/School/MIT/UROP_PLV"'
alias mcdermott='cd "$HOME/Dropbox/Main/School/MIT/UROP_McDermott"'
alias pdos='cd "$HOME/Dropbox/Main/School/MIT/UROP_PDOS"'
alias dmain='cd "$HOME/Dropbox/Main/"'
alias dacc='cd "$HOME/Dropbox/Main/Notes/Obsidian Vault/Personal/Monies"'
alias ddev='cd "$HOME/Documents/Dev"'

alias pwdyy='pwd | xclip -selection clipboard'
alias chkspace='sudo du -d 1 -h | sort -h'
alias chkbat='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias kubectl="minikube kubectl --"
alias PYRUN='PYLSL_LIB=/home/lyc/mambaforge/envs/bci-hackathon/lib/liblsl.so python3'
# global alias: append to any command, e.g. `make NOTIFY`
alias -g NOTIFY=' && notify-send "job done" || notify-send "job failed"'

# ----- functions -----
mvctf() {
    mv "$@" ~/Documents/VMShare/kali-ctf
}

nobg() {
    convert $1 -fuzz 0% -transparent white $1.clean
}

mkcode() {
    mkdir $1
    cd $1
    touch in.txt
    vim $1.cpp
}

serve_static() {
    python3 -m http.server 8080 --bind 0.0.0.0
}

pause() {
    read -p "Press enter to continue"
}

svg2png() {
    f="${1%.*}"
    inkscape -w 2048 "$f.svg" -o "$f.png" && xdg-open "$f.png"
}

wez_rename_tab() {
    printf "\x1b]2;$1\x1b\\"
}

# close hook
finish() {
    echo bye
}
trap finish EXIT

# ----- tool init -----
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
