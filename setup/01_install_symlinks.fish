for file in (find ~/.config/fish/_symlinks | tail -n +2)
    set -l relative (string replace "$HOME/.config/fish/_symlinks/" "" $file)
    if test (dirname $relative | string trim -c ".") != ""
        mkdir -p $HOME/(dirname $relative)
    end
    if ln -s $file $HOME/$relative 2>/dev/null
        _with_color green echo "Link created: $relative => $HOME/$relative"
    else
        _with_color red echo "File already exists: $HOME/$relative"
    end
end
