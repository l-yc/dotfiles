# Environment variables

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
