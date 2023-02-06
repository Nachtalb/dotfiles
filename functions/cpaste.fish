function cpaste --description "Print clipboard data to STOUT"
    if command -q pbpaste
        pbpaste
    else if command -q wl-copy
        wl-paste
    else if command -q xclip
        xclip -o -sel clip
    else if command -q xsel
        xsel -o -b
    else if command -q lemonade
        lemonade paste
    else if command -q win32yank.exe
        win32yank.exe -o -lf
    else if command -q termunx-clipboard-set
        termunx-clipboard-get
    else if command -q powershell.exe
        powershell.exe -c "Get-Clipboard"
    else if test -n $TMUX; and command -q tmux
        tmux save-buffer -
    else
        echo "No supported clipboard util found"
    end
end

