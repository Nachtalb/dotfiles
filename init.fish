###############################################################################
# Colours                                                                     #
###############################################################################

set fish_color_autosuggestion grey


###############################################################################
# Set globals                                                                 #
###############################################################################
set -gx PYTHONDONTWRITEBYTECODE 1  # Python won’t try to write .pyc or .pyo files on the import of source modules
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Disable default virtualenv prompt
set -gx PYTHONSTARTUP $HOME/.pythonrc  # Load pythonrc file
set -gx HOMEBREW_NO_AUTO_UPDATE 1  # Do not update on installation in homebrew
set -gx GPG_TTY (tty)  # Load gpg
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)  # Set default java version

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

tmux-terminal-color  # set the $TERM to screen-color256 when inside $TMUX
