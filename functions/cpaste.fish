function cpaste --description "Print clipboard data to STOUT"
    if set -q CPASTE
        $CPASTE
    else if command -q pbpaste
        pbpaste
        set -gx CPASTE "pbpaste"
    else if command -q wl-copy
        wl-paste
        set -gx CPASTE "wl-paste"
    else if command -q xclip
        xclip -o -sel clip
        set -gx CPASTE "xclip" "-o" "-sel" "clip"
    else if command -q xsel
        xsel -o -b
        set -gx CPASTE "xsel" "-o" "-b"
    else if command -q lemonade
        lemonade paste
        set -gx CPASTE "lemonade" "paste"
    else if command -q win32yank.exe
        win32yank.exe -o --lf
        set -gx CPASTE "win32yank.exe" "-o" "--lf"  # win32yank.exe has about double the performance of powershell.exe -c Get-Clipboard
    else if command -q termunx-clipboard-set
        termunx-clipboard-get
        set -gx CPASTE "termunx-clipboard-set"
    else if command -q powershell.exe
      powershell.exe -c "Get-Clipboard"
      set -gx CPASTE "powershell.exe" "-c" "Get-Clipboard"
    else if test -n $TMUX; and command -q tmux
        tmux save-buffer -
        set -gx CPASTE "save-buffer" "-"
    else
        echo "No supported clipboard util found"
    end
end

