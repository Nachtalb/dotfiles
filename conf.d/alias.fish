status is-interactive || exit

alias timestamp='date +%s'
alias j z  # j by habbit due to autojump

if not command -q tree
    alias tree 'exa --tree'
end

alias gr 'cd (git rev-parse --show-toplevel)'

# Replace ls with exa
if command -q exa
    alias ls='exa --color=always --group-directories-first --icons' # preferred listing
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias la='exa -al --color=always --group-directories-first --icons'  # all files and dirs
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
end
alias ip="ip -color"


# Replace some more things with better alternatives
if command -q bat
    alias cat='bat --style header --style rule --style snip --style changes --style header --wrap never --pager "less -RF"'
end

[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

if command -q pacman
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"
    alias rmpkg="sudo pacman -Rdd"

    # Cleanup orphaned packages
    alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

    # Recent installed packages
    alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

    # List amount of -git packages
    alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
end

# Common use
alias wget='wget -c '
alias grep='grep --color=auto'

