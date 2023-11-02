set START (date +%s%3N)
function spent -a suffix -d "How much time has gone by since start config.fish in ms"
  echo $START - (math (date +%s%3N) - $START) - $suffix
end


function st
  if begin; isatty; or status --is-interactive; or test -z "$INSIDE_EMACS"; or not set -q NOTMUX; end
    if not set -q TMUX
      set -l session_name local
      if tmux has-session -t $session_name 2> /dev/null
          exec tmux new-session -t $session_name \; set destroy-unattached on
      else
          exec tmux new-session -s $session_name
      end
    end
  end
end

if test -f ~/.config/fish/settings/autostart-tmux
  st
else
  echo "Create ~/.config/fish/settings/autostart-tmux to enable autostart tmux"
end

set -gx JAVA_HOME /usr/lib/jvm/default
# Hide welcome message
set fish_greeting

if status is-interactive
    # Starship prompt
    if test -f "/usr/bin/starship"
        source ("/usr/bin/starship" init fish --print-full-init | psub)
    end
    if test -f "/usr/local/bin/starship"
        source ("/usr/local/bin/starship" init fish --print-full-init | psub)
    end

    # Advanced command-not-found hook for pacman
    if test -f /usr/share/doc/find-the-command/ftc.fish
        source /usr/share/doc/find-the-command/ftc.fish
    end
    exit
end


## Export variable need for qt-theme
# if type "qtile" >> /dev/null 2>&1
#    set -x QT_QPA_PLATFORMTHEME "qt5ct"
# end

## Enviromental vars
set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx PYTHONUNBUFFERED 1  # Force stdin, stdout and stderr to be totally unbuffered.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx PYTHON_CONFIGURE_OPTS "--enable-shared"
set -gx GPG_TTY (tty)  # Load gpg
set -gx GO111MODULE on
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"
set -gx NACHTALB_DOTFILES "1"

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
if test -f ~/.config/fish/settings/wayland
    set -gx QT_QPA_PLATFORM "wayland"
    set -gx QT_QPA_PLATFORMTHEME qt5ct
    set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
    set -gx _JAVA_AWT_WM_NONREPARENTING 1
end

## SWAY
# set default shell and terminal
if test -f /usr/share/sway/scripts/foot.sh
    set -gx TERMINAL_COMMAND  /usr/share/sway/scripts/foot.sh
end

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
    $HOME/.local/share/gem/ruby/3.0.0/bin \
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

if begin; type -q vpn-start; and not test -f ~/.config/vpn-stopped; end
  vpn-start
end

# bun
set --export BUN_INSTALL "$HOME/.reflex/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
