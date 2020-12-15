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

export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll='ls -al --color=auto'
alias vim='vimx'
alias vimm='vimx --cmd "let g:vimMinimal=1"'
***REMOVED***
alias school='cd "/home/lyc/Dropbox/Ninjabobo5/!School-Work/Y5"'
alias andev='cd "/home/lyc/OneDrive/CS4131/"'
#alias androidStudioVar='export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly'
alias osuVar='export LD_LIBRARY_PATH="$(pwd)/osu.Desktop/bin/Debug/netcoreapp2.2"'
alias pwdyy='pwd | xclip -selection clipboard'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias docker='podman'
alias chkspace='sudo du -d 1 -h | sort -h'
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

present() {
    bspc monitor HDMI-1 -d X
    xrandr --output HDMI-1 --auto --scale 2.0x2.0 --right-of eDP-1
}

external_monitor() {
	pkill sxhkd
    if [[ "$1" == "--restore" ]]; then
        xrandr --output HDMI-1 --off --output eDP-1 --mode 1920x1080
        bspc monitor eDP-1 -d I II III IV V VI VII VIII IX
        PRIMARY=eDP-1 sxhkd &
    elif [[ "$1" == "--dual" ]]; then
        xrandr --output HDMI-1 --mode 1920x1080 --output eDP-1 --mode 1920x1080 --right-of HDMI-1
        bspc monitor HDMI-1 -d I II III IV V VI VII VIII IX
        bspc monitor eDP-1 -d X
        PRIMARY=HDMI-1 SECONDARY=eDP-1 sxhkd &
    else
        xrandr --output HDMI-1 --mode 1920x1080 --same-as eDP-1 --output eDP-1 --off
        bspc monitor HDMI-1 -d I II III IV V VI VII VIII IX
        PRIMARY=HDMI-1 sxhkd &
    fi
    $HOME/.config/polybar/launch.sh
}

mkcode() {
    mkdir $1
    cd $1
    touch in.txt
    #vim $1.cpp
    cp ~/Templates/ans.cpp $1.cpp
    geany $1.cpp
}

#copy the section below into your .bashrc and uncomment to turn on auto save
finish() {
    echo bye
}

trap finish EXIT


source /home/lyc/bin/hoard
source <(kitty + complete setup bash)
