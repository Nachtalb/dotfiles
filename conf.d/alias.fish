status is-interactive || exit

alias timestamp='date +%s'
alias j z  # j by habbit due to autojump

if not command -q tree
    alias tree 'exa --tree'
end

alias gr 'cd (git rev-parse --show-toplevel)'
