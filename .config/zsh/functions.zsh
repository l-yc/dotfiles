# Functions

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
