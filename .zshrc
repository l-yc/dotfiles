# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/lyc/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# copied from bashrc
# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$PATH:$HOME/Android/Sdk/platform-tools"
PATH="$PATH:/var/lib/flatpak/exports/bin"
PATH="$PATH:/var/lib/snapd/snap/bin"
PATH="$PATH:~/CodeSourcery/arm-2009q1/bin/"
PATH="$PATH:$HOME/.flush/scripts/"

export GOPATH="$HOME/Documents/LocalDev/go"
PATH="$PATH:$GOPATH/bin"
export PATH

export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly
export QT_AUTO_SCREEN_SCALE_FACTOR=0.5 # for qt apps like calibre to not appear huge

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias lll='ls -al --color=auto'
alias ll='exa -l --group-directories-first --git'
alias vim='nvim'
alias vimm='nvim --cmd "let g:level=0"'
alias vimmm='nvim --cmd "let g:level=-1"'
alias _vimm='vimx --cmd "let g:vimMinimal=1"'
alias dcode='cd "/home/lyc/Dropbox/Main/Code/CP"'
alias school='cd "/home/lyc/Dropbox/Main/School/Y6"'
alias pwdyy='pwd | xclip -selection clipboard'
alias docker='podman'
alias chkspace='sudo du -d 1 -h | sort -h'
alias chkbat='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# /etc/sysconfig/network-scripts/

# Add this to your .bashrc, .zshrc or equivalent.
# Run 'fff' with 'f' or whatever you decide to name the function.
fffg() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

toprint() {
    echo "-----TO PRINT-----"
    ls -A1 ~/Documents/0TO_PRINT
}

mvprint() {
    mv "$@" ~/Documents/0TO_PRINT
}

mvctf() {
    mv "$@" ~/Documents/VMShare/kali-ctf
}

nobg() {
    convert $1 -fuzz 0% -transparent white $1.clean
}

todo() {
    echo
    echo
    cat ~/Documents/Todo.md
    echo
    toprint
    echo
    echo
}

mkcode() {
    mkdir $1
    cd $1
    touch in.txt
    vim $1.cpp
    #cp ~/Templates/ans.cpp $1.cpp
    #geany $1.cpp
}

ypl() {
    hoard o ypl
    source venv/bin/activate
    python main.py
}

serve_static() {
    python3 -m http.server 8080 --bind 127.0.0.1
}

pause() {
    read -p "Press enter to continue"
    #read -n 1 -s -r -p "Press any key to continue"
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



source <(kitty + complete setup bash)
alias config='/usr/bin/git --git-dir=/home/lyc/.cfg/ --work-tree=/home/lyc'
#. "/home/lyc/bin/hoard"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
