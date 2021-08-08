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
#PATH="$PATH:/usr/local/go/bin"
#PATH=$PATH:$(go env GOPATH)/bin
PATH="$PATH:$GOPATH/bin"
export PATH

export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias lll='ls -al --color=auto'
alias ll='exa -l --group-directories-first --git'
alias vim='vimx'
alias vimm='vimx --cmd "let g:vimMinimal=1"'
***REMOVED***
***REMOVED***
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
    bspc monitor HDMI-A-0 -d X
    #xrandr --output HDMI-A-0 --auto --scale 2.0x2.0 --right-of eDP
    xrandr --output HDMI-A-0 --auto --same-as eDP
}

external_monitor() {
	pkill sxhkd
    if [[ "$1" == "--restore" ]]; then
        xrandr --output HDMI-A-0 --off --output eDP --mode 1920x1080
        bspc monitor eDP -d I II III IV V VI VII VIII IX
        bspc monitor HDMI-A-0 -d
        export PRIMARY=eDP 
    elif [[ "$1" == "--dual" ]]; then
        xrandr --output HDMI-A-0 --mode 1920x1080 --output eDP --mode 1920x1080 --right-of HDMI-A-0
        bspc monitor HDMI-A-0 -d I II III IV V VI VII VIII IX
        bspc monitor eDP -d X
        export PRIMARY=HDMI-A-0 SECONDARY=eDP
    elif [[ "$1" == "--present" ]]; then
        #xrandr --output HDMI-A-0 --mode 1920x1080 --right-of eDP --output eDP --mode 1920x1080
        #xrandr --output HDMI-A-0 --auto --right-of eDP --output eDP --mode 1920x1080
        #xrandr --output HDMI-A-0 --mode 640x480 --right-of eDP --output eDP --mode 1920x1080
        xrandr --output HDMI-A-0 --mode $2 --right-of eDP --output eDP --mode 1920x1080
        bspc monitor eDP -d I II III IV V VI VII VIII IX
        bspc monitor HDMI-A-0 -d X
        export PRIMARY=eDP SECONDARY=HDMI-A-0
    elif [[ "$1" == "--mirror" ]]; then # bar will die and show HDMI, which has nothing
        xrandr --output HDMI-A-0 --mode 1920x1080 --same-as eDP --output eDP --mode 1920x1080 --primary
        bspc monitor eDP -d I II III IV V VI VII VIII IX
        bspc monitor HDMI-A-0 -d
        export PRIMARY=eDP
    else
        xrandr --output HDMI-A-0 --mode 1920x1080 --same-as eDP --output eDP --off
        bspc monitor HDMI-A-0 -d I II III IV V VI VII VIII IX
        bspc monitor eDP -d
        export PRIMARY=HDMI-A-0
    fi
    #nohup sxhkd -r sxhkd.out &
    $HOME/.config/sxhkd/launch.sh
    $HOME/.config/polybar/launch.sh
}

mkcode() {
    mkdir $1
    cd $1
    touch in.txt
    vim $1.cpp
    #cp ~/Templates/ans.cpp $1.cpp
    #geany $1.cpp
}

mark() {
    # (.*\/)?([^\/]+)(\/.*)?$

    if [ -z "$2" ]; then
        echo "usage: -(u|s) <filename>"
        return
    fi

    cur=`echo $2 | sed -E 's/(.*\/)?([^\/]+)(\/.*)?$/\2/g'`
    echo "renaming... $cur"

    if [[ $1 == "-u" ]]; then
        echo "mark as unsolved"
        new="_$cur"
    elif [[ $1 == "-s" ]]; then
        echo "mark as solved"
        new="${cur}_"
    else
        echo "unknown flag"
        return
    fi

    mv "$cur" "$new"
}

unzipper() {
    filename="${1%.*}"
    if zip --show-files $1 | grep -q "creating: $filename/"; then
        echo "File is wrapped properly."
        unzip "$1"
    else
        echo "Creating $filename directory"
        mkdir "$filename"
        mv "$1" "$filename"
        cd "$filename"
        if [[ "$?" -ne "0" ]]; then
            echo "ERROR!"
            return
        fi
        unzip "$1"
        mv "$1" ..
        cd ..
    fi
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

#copy the section below into your .bashrc and uncomment to turn on auto save
finish() {
    echo bye
}

trap finish EXIT



source <(kitty + complete setup bash)
alias config='/usr/bin/git --git-dir=/home/lyc/.cfg/ --work-tree=/home/lyc'
. "/home/lyc/bin/hoard"
