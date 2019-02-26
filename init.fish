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
set -gx HOMEBREW_NO_AUTO_UPDATE 1  # Do not update on installation in homebrew
set -gx GPG_TTY (tty)  # Load gpg
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)  # Set default java version

# Expand $PATH
set -gx PATH $PATH $HOME/.config/omf/bin
set -gx PATH $PATH /usr/local/opt/sphinx-doc/bin
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
set -gx GH_BASE_DIR $HOME/Development
set -gx GL_BASE_DIR $HOME/Development
set -gx GB_BASE_DIR $HOME/Development

# OpenSSL configuration
set -gx LDFLAGS -L/usr/local/opt/openssl/lib
set -gx CPPFLAGS -I/usr/local/opt/openssl/include

# Add etcher-cli if available
if test -d /opt/etcher-cli
    set -gx PATH /opt/etcher-cli $PATH
end

# Enable iTerm2 tmux integration
set -gx ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX 1


###############################################################################
# Load tools                                                                  #
###############################################################################

# Own configurations
source ~/.config/omf/abbreviations.fish
source ~/.config/omf/alias.fish
source ~/.config/omf/hooks.fish

# Pyenv
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

# Rbevn
status --is-interactive; and source (rbenv init -|psub)

# direnv
eval (direnv hook fish)

# Git ignored files
for filename in ~/.config/omf/user/*.fish
    source $filename
end

# Own scripts
for file in ~/.config/omf/scripts/*.fish
    source $file
end

# Autojump
if test -f ~/.autojump/share/autojump/autojump.fish
    source ~/.autojump/share/autojump/autojump.fish
end

