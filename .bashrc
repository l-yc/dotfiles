# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$PATH:$HOME/Android/Sdk/platform-tools"
PATH="$PATH:/var/lib/flatpak/exports/bin"
PATH="$PATH:/var/lib/snapd/snap/bin"
#PATH="$PATH:~/CodeSourcery/arm-2009q1/bin/:/home/lyc/Downloads/tmp/ev3/c4ev3/arm-linux-gnueabi"
PATH="$PATH:~/CodeSourcery/arm-2009q1/bin/"

export GOPATH="$HOME/Documents/LocalDev/go"
PATH="$PATH:/usr/local/go/bin"
#PATH=$PATH:$(go env GOPATH)/bin
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll='ls -al --color=auto'
alias vim='vimx'
alias vimm='vimx --cmd "let g:vimMinimal=1"'
***REMOVED***
alias school='cd "/home/lyc/Dropbox/Ninjabobo5/!School-Work/Y5"'
alias andev='cd "/home/lyc/OneDrive/CS4131/"'
alias androidStudioVar='export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly'
alias osuVar='export LD_LIBRARY_PATH="$(pwd)/osu.Desktop/bin/Debug/netcoreapp2.2"'
alias pwdyy='pwd | xclip -selection clipboard'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# /etc/sysconfig/network-scripts/

# Add this to your .bashrc, .zshrc or equivalent.
# Run 'fff' with 'f' or whatever you decide to name the function.
fffg() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

# Powerline
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

toprint() {
    echo "-----TO PRINT-----"
    ls -A1 ~/Documents/0TO_PRINT
}

mvprint() {
    mv "$@" ~/Documents/0TO_PRINT
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

#copy the section below into your .bashrc and uncomment to turn on auto save
finish() {
    echo bye
}

trap finish EXIT


source /home/lyc/bin/hoard
source <(kitty + complete setup bash)
