# Make sure this is before the 'exec' command or it won't be sourced.
xrandr --output eDP-1 --scale 0.75x0.75
export _JAVA_AWT_WM_NONREPARENTING=1 # for java apps to display properly

# https://wiki.archlinux.org/index.php/PC_speaker

[ -f ~/.Xresources ] && xrdb -load ~/.Xresources
xset +fp ~/.local/share/fonts
xset +fp /home/lyc/.fonts
xset fp rehash

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
#exec /usr/bin/bspwm
exec /usr/bin/sway
