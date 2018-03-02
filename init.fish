# Python developers otherwise
set -gx PYTHONDONTWRITEBYTECODE 1

# Disable default virtualenv prompt
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Lang setting
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -gx VISUAL vim
set -gx EDITOR $VISUAL

set -gx LESSOPEN "| /usr/local/bin/source-highlight-esc.sh %s"
set -gx LESS ' -R '

# Add etcher-cli if available
if test -d /opt/etcher-cli
    set -gx PATH /opt/etcher-cli $PATH
end

# GH config
set -gx GH_BASE_DIR '/Users/bernd/Development'
set -gx GL_BASE_DIR '/Users/bernd/Development'
set -gx GB_BASE_DIR '/Users/bernd/Development'

# Load pyenv
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

# Load GPG
set -gx GPG_TTY (tty)

source ~/.config/omf/abbreviations.fish
source ~/.config/omf/hooks.fish
source ~/.config/omf/servers.fish
