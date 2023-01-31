## Make sure this is before the 'exec' command or it won't be sourced.
#xrandr --output eDP-1 --scale 0.75x0.75
#export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly
#
## https://wiki.archlinux.org/index.php/PC_speaker
#
#[ -f ~/.Xresources ] && xrdb -load ~/.Xresources
#xset +fp ~/.local/share/fonts
#xset +fp /home/lyc/.fonts
#xset fp rehash
#
#[ -f /etc/xprofile ] && . /etc/xprofile
#[ -f ~/.xprofile ] && . ~/.xprofile

# https://github.com/microsoft/vscode/issues/120392#issuecomment-814210643
# init keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# export keyring
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

exec dbus-launch i3 --shmlog-size=26214400
