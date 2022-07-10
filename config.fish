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

# Connect to the TMUX session if it exists, or create it if it doesn't.
if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx PYTHONUNBUFFERED 1  # Force stdin, stdout and stderr to be totally unbuffered.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx PYTHON_CONFIGURE_OPTS "--enable-shared"
set -gx GPG_TTY (tty)  # Load gpg
set -gx JAVA_HOME (readlink -f /usr/bin/javac | sed "s:/bin/javac::")
set -gx GO111MODULE on

set -gx VISUAL nvim
set -gx EDITOR $VISUAL

for p in /usr/bin/{chromium,microsoft-edge,microsoft-edge-dev}
    if test -f $p
        set -gx BROWSER
    end
end

if test (loginctl show-session (loginctl | awk '/tty/ {print $1}') -p Type | cut -d= -f2) = 'wayland'
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

# set default shell and terminal
if test -f /usr/share/sway/scripts/foot.sh
    set -gx TERMINAL_COMMAND  /usr/share/sway/scripts/foot.sh
end

# add default location for zeit.db
set -gx ZEIT_DB ~/.config/zeit.db

# Expand $PATH
set -l NewPaths \
    /usr/local/go/bin \
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


# Do not show notification if terminal is focused
set -U __done_sway_ignore_visible 1
