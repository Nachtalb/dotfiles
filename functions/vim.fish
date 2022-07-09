function vim --wraps="vim"
    test -f Session.vim && nvim -S Session.vim $argv || nvim $argv
end
