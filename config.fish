set START (date +%s%3N)
function spent -a suffix -d "How much time has gone by since start config.fish in ms"
  echo $START - (math (date +%s%3N) - $START) - $suffix
end

# spent 1

function st
  if begin; test -z "$INSIDE_EMACS"; and test -z "$NOTMUX"; and isatty; and status --is-interactive; end
    if not set -q TMUX
      set -l session_name local
      if tmux has-session -t $session_name 2> /dev/null
        exec env -- tmux new-session -t $session_name \; set destroy-unattached on
      else
        exec env -- tmux new-session -s $session_name
      end
    end
  end
end

if not string match -q -- "*icrosoft*" (uname -r)
  # Automatically start tmux if we are not in a WSL environment
  st
end

# spent 2
# Hide welcome message
set fish_greeting

# spent 3
## Useful aliases
# Replace ls with exa
if command -q exa
    alias ls='exa --color=always --group-directories-first --icons' # preferred listing
    alias ll='exa -l --color=always --group-directories-first --icons'  # long format
    alias la='exa -al --color=always --group-directories-first --icons'  # all files and dirs
    alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
end
alias ip="ip -color"

# spent 4

# Replace some more things with better alternatives
if command -q bat
    alias cat='bat --style header --style rule --style snip --style changes --style header'
end

# spent 5
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# spent 6
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

# spent 7
# Common use
alias wget='wget -c '
alias grep='grep --color=auto'

# spent 11
if status is-interactive
    # Starship prompt
    if test -f "/usr/bin/starship"
        source ("/usr/bin/starship" init fish --print-full-init | psub)
    end
    if test -f "/usr/local/bin/starship"
        source ("/usr/local/bin/starship" init fish --print-full-init | psub)
    end

# spent 12
    # Advanced command-not-found hook for pacman
    if test -f /usr/share/doc/find-the-command/ftc.fish
        source /usr/share/doc/find-the-command/ftc.fish
    end
    exit
end

# spent 13

## Export variable need for qt-theme
# if type "qtile" >> /dev/null 2>&1
#    set -x QT_QPA_PLATFORMTHEME "qt5ct"
# end

# spent 14
## Enviromental vars
set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx PYTHONUNBUFFERED 1  # Force stdin, stdout and stderr to be totally unbuffered.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx PYTHON_CONFIGURE_OPTS "--enable-shared"
set -gx GPG_TTY (tty)  # Load gpg
set -gx GO111MODULE on
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx NACHTALB_DOTFILES "1"

# spent 15
# Set settings for https://github.com/franciscolourenco/done
set -gx __done_min_cmd_duration 10000
set -gx __done_notification_urgency_level low

# spent 16
set -gx VISUAL nvim
set -gx EDITOR $VISUAL

# spent 17
for p in /usr/bin/{chromium,microsoft-edge,microsoft-edge-beta,microsoft-edge-dev}
    if test -f $p
        set -gx BROWSER $p
        break
    end
end

# spent 18

## WAYLAND
# if pidof systemd 1>/dev/null; and test (loginctl show-session 2 -p Type | awk -F= '{print $2}') = 'wayland'
#     # Most pure GTK3 apps use wayland by default, but some,
#     # like Firefox, need the backend to be explicitely selected.
#     set -gx GTK_CSD 0
#
#     # qt wayland
#     set -gx QT_QPA_PLATFORM "wayland"
#     set -gx QT_QPA_PLATFORMTHEME qt5ct
#     set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
#
#     #Java XWayland blank screens fix
#     set -gx _JAVA_AWT_WM_NONREPARENTING 1
# end

# spent 19
## SWAY
# set default shell and terminal
if test -f /usr/share/sway/scripts/foot.sh
    set -gx TERMINAL_COMMAND  /usr/share/sway/scripts/foot.sh
end

# spent 20
# Do not show notification if terminal is focused
set -U __done_sway_ignore_visible 1

# spent 21
## PATH EXPANSION
# Expand $PATH
set -l NewPaths \
    /usr/local/go/bin \
    $HOME/.local/bin \
    $HOME/.yarn/bin \
    $HOME/.cargo/bin \
    $HOME/.config/fish/bin \
    $HOME/.local/share/gem/ruby/3.0.0/bin \
    $HOME/bin/

# spent 22
for p in $NewPaths
    if test -d $p
        fish_add_path $p
    end
end

# GH config
set -gx GH_BASE_DIR $HOME/src
set -gx GL_BASE_DIR $HOME/src
set -gx GB_BASE_DIR $HOME/src
