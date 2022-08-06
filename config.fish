# If we're not running in an interactive terminal, do nothing.
if begin; isatty; or status --is-interactive; or test -z "$INSIDE_EMACS"; or not set -q NOTMUX; end
    if not set -q TMUX
        set -l session_name local
        if tmux has-session -t $session_name 2> /dev/null
            exec env -- tmux new-session -t $session_name \; set destroy-unattached on
        else
            exec env -- tmux new-session -s $session_name
        end
    end
end

# Hide welcome message
set fish_greeting

## Useful aliases
# Replace ls with exa
if command -q exa
    alias ls='exa --color=always --group-directories-first --icons' # preferred listing
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias la='exa -al --color=always --group-directories-first --icons'  # all files and dirs
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
    alias l.="la | egrep '^\.'"                                     # show only dotfiles
end
alias ip="ip -color"

# Replace some more things with better alternatives
if command -q bat
    alias cat='bat --style header --style rules --style snip --style changes --style header'
end

[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

if command -q pacman
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"
    alias rmpkg="sudo pacman -Rdd"

    # Help people new to Arch
    alias apt='man pacman'
    alias apt-get='man pacman'

    # Cleanup orphaned packages
    alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

    # Recent installed packages
    alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
end

# Common use
alias grubup="sudo update-grub"
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias upd='/usr/bin/garuda-update'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

if status is-interactive
    if test -f "/usr/bin/starship"
        # Starship prompt
        source ("/usr/bin/starship" init fish --print-full-init | psub)
    end

    if test -f /usr/share/doc/find-the-command/ftc.fish
        # Advanced command-not-found hook for pacman
        source /usr/share/doc/find-the-command/ftc.fish
    end
    exit
end

## Export variable need for qt-theme
if type "qtile" >> /dev/null 2>&1
   set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

## Enviromental vars
set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx PYTHONUNBUFFERED 1  # Force stdin, stdout and stderr to be totally unbuffered.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx PYTHON_CONFIGURE_OPTS "--enable-shared"
set -gx GPG_TTY (tty)  # Load gpg
set -gx JAVA_HOME (readlink -f /usr/bin/javac | sed "s:/bin/javac::")
set -gx GO111MODULE on
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -gx __done_min_cmd_duration 10000
set -gx __done_notification_urgency_level low

set -gx VISUAL nvim
set -gx EDITOR $VISUAL

for p in /usr/bin/{chromium,microsoft-edge,microsoft-edge-beta,microsoft-edge-dev}
    if test -f $p
        set -gx BROWSER $p
        break
    end
end

## WAYLAND
if pidof systemd; and test (loginctl show-session 2 -p Type | awk -F= '{print $2}') = 'wayland'
    # Most pure GTK3 apps use wayland by default, but some,
    # like Firefox, need the backend to be explicitely selected.
    set -gx GTK_CSD 0

    # qt wayland
    set -gx QT_QPA_PLATFORM "wayland"
    set -gx QT_QPA_PLATFORMTHEME qt5ct
    set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION "1"

    #Java XWayland blank screens fix
    set -gx _JAVA_AWT_WM_NONREPARENTING 1
end

## SWAY
# set default shell and terminal
if test -f /usr/share/sway/scripts/foot.sh
    set -gx TERMINAL_COMMAND  /usr/share/sway/scripts/foot.sh
end

# add default location for zeit.db
set -gx ZEIT_DB ~/.config/zeit.db

# Do not show notification if terminal is focused
set -U __done_sway_ignore_visible 1

## PATH EXPANSION
# Expand $PATH
set -l NewPaths \
    /usr/local/go/bin \
    $HOME/.local/bin \
    $HOME/.yarn/bin \
    $HOME/.cargo/bin \
    $HOME/.config/fish/bin \
    $HOME/bin/

for p in $NewPaths
    if test -d $p
        fish_add_path $p
    end
end

# GH config
set -gx GH_BASE_DIR $HOME/src
set -gx GL_BASE_DIR $HOME/src
set -gx GB_BASE_DIR $HOME/src
