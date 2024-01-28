function vim --wraps "nvim"
    if test (count $argv) -eq 0
        test -f Session.vim && nvim -S Session.vim $argv || nvim
    else
        nvim $argv
    end
end
