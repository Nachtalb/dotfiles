function ccopy --description "Copy data from STDIN to the clipboard"
    if set -q CCOPY
        read -z | $CCOPY
        return
    else if command -q pbcopy
        read -z | pbcopy
        set -gx "CCOPY" "pbcopy"
    else if command -q wl-copy
        read -z | wl-copy
        set -gx "CCOPY" "wl-copy"
    else if command -q xclip
        read -z | xclip -sel clip
        set -gx "CCOPY" "xclip" "-sel" "clip"
    else if command -q xsel
        read -z | xsel -ibs
        set -gx "CCOPY" "xsel" "-ibs"
    else if command -q lemonade
        read -z | lemonade copy
        set -gx "CCOPY" "lemonade" "copy"
    else if command -q clip.exe
        read -z | clip.exe
        set -gx "CCOPY" "clip.exe"  # clip.exe has about double the performance of win32yank.exe
    else if command -q win32yank.exe
        read -z | win32yank.exe -i -clrf
        set -gx "CCOPY" "win32yank.exe" "-i" "-clrf"
    else if command -q termunx-clipboard-set
        read -z | termunx-clipboard-set
        set -gx "CCOPY" "termunx-clipboard-set"
    else if test -n $TMUX; and command -q tmux
        read -z | tmux load-buffer -
        set -gx "CCOPY" "tmux load-buffer -"
    else
        echo "No supported clipboard util found"
    end
end

