# Initialize the current fish session and connect to the tmux session.
# If we're not running in an interactive terminal, do nothing.
if begin; not isatty; or not status --is-interactive; or test -n "$INSIDE_EMACS"; end
  exit
end

# Connect to the TMUX session if it exists, or create it if it doesn't.
if not set -q TMUX
  set -l session_name local
  if tmux has-session -t $session_name 2> /dev/null
    exec env -- tmux new-session -t $session_name \; set destroy-unattached on \; new-window
  else
    exec env -- tmux new-session -s $session_name
  end
  exit
end

###############################################################################
# Colours                                                                     #
###############################################################################

set fish_color_autosuggestion grey


###############################################################################
# Set globals                                                                 #
###############################################################################
set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx PYTHONUNBUFFERED 1  # Force stdin, stdout and stderr to be totally unbuffered.
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx GPG_TTY (tty)  # Load gpg

# Expand $PATH
set -gx PATH $PATH $HOME/.config/omf/bin
set -gx PATH ~/bin/ $PATH

# Lang setting
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Use vim as default editor
set -gx VISUAL vim
set -gx EDITOR $VISUAL

# Syntax higlighting for less
set -gx LESSOPEN "| /usr/local/bin/source-highlight-esc.sh %s"
set -gx LESS ' -R '

# GH config
set -gx GH_BASE_DIR $HOME/src
set -gx GL_BASE_DIR $HOME/src
set -gx GB_BASE_DIR $HOME/src


###############################################################################
# Load tools                                                                  #
###############################################################################

# Own configurations
source ~/.config/omf/abbreviations.fish
source ~/.config/omf/alias.fish
source ~/.config/omf/hooks.fish

# Add etcher-cli if available
if test -d /opt/etcher-cli
    set -gx PATH /opt/etcher-cli $PATH
end

# Pyenv
if type -q pyenv
    status --is-interactive; and source (pyenv init -|psub)
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end

# Rbevn
if type -q rbenv
    status --is-interactive; and source (rbenv init -|psub)
end

# direnv
if type -q direnv
    eval (direnv hook fish)
end

# Load https://github.com/wting/autojump
if test -f /home/bernd/.autojump/share/autojump/autojump.fish
    source /home/bernd/.autojump/share/autojump/autojump.fish
end

# Git ignored files
for file in ~/.config/omf/user/*.fish
    source $file
end

# Own scripts
for file in ~/.config/omf/scripts/*.fish
    source $file
end

