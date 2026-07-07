# Aliases

# ls / editors
alias lll='ls -al --color=auto'
alias ll='ls -alh'
alias vim='nvim'
alias vimm='nvim --cmd "let g:level=0"'
alias vimmm='nvim --cmd "let g:level=-1"'
alias emacs='emacs-nox'

# directory shortcuts
alias dcode='cd "$HOME/Dropbox/Main/Code/CP"'
alias school='cd "$HOME/Dropbox/Main/School/MIT/Fall_2025"'
alias work='cd "$HOME/Dropbox/Main/Work"'
alias plv='cd "$HOME/Dropbox/Main/School/MIT/UROP_PLV"'
alias mcdermott='cd "$HOME/Dropbox/Main/School/MIT/UROP_McDermott"'
alias pdos='cd "$HOME/Dropbox/Main/School/MIT/UROP_PDOS"'
alias dmain='cd "$HOME/Dropbox/Main/"'
alias dacc='cd "$HOME/Dropbox/Main/Notes/Obsidian Vault/Personal/Monies"'
alias ddev='cd "$HOME/Documents/Dev"'

# utilities
alias pwdyy='pwd | xclip -selection clipboard'
alias chkspace='sudo du -d 1 -h | sort -h'
alias chkbat='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias kubectl="minikube kubectl --"
alias PYRUN='PYLSL_LIB=/home/lyc/mambaforge/envs/bci-hackathon/lib/liblsl.so python3'
# global alias: append to any command, e.g. `make NOTIFY`
alias -g NOTIFY=' && notify-send "job done" || notify-send "job failed"'
