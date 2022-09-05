function ccopy --description "Copy data from STDIN to the clipboard"
    if command -q pbcopy
        read -z | pbcopy
    else if command -q wl-copy
        read -z | wl-copy
    else if command -q xclip
        read -z | xclip -sel clip
    else if command -q xsel
        read -z | xsel -ibs
    else if command -q lemonade
        read -z | lemonade copy
    else if command -q win32yank.exe
        read -z | win32yank.exe -i -clrf
    else if command -q termunx-clipboard-set
        read -z | termunx-clipboard-set
    else if test -n $TMUX; and command -q tmux
        read -z | tmux load-buffer -
    else
        echo "No supported clipboard util found"
    end
end

