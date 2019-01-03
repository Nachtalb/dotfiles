# Python developers otherwise
set -gx PYTHONDONTWRITEBYTECODE 1
# Disable default virtualenv prompt
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
# Load pythonrc file
set -gx PYTHONSTARTUP $HOME/.pythonrc

# Do not update on installation in homebrew
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# Lang setting
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -gx VISUAL vim
set -gx EDITOR $VISUAL

set -gx LESSOPEN "| /usr/local/bin/source-highlight-esc.sh %s"
set -gx LESS ' -R '

# Add user local ~/bin/ to path
set -gx PATH ~/bin/ $PATH

# Add etcher-cli if available
if test -d /opt/etcher-cli
    set -gx PATH /opt/etcher-cli $PATH
end

# Add scripts directory to PATH var
set -gx PATH $PATH $HOME/.config/omf/bin

# GH config
set -gx GH_BASE_DIR $HOME/Development
set -gx GL_BASE_DIR $HOME/Development
set -gx GB_BASE_DIR $HOME/Development

# Load pyenv
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)

# Load rbenv
status --is-interactive; and source (rbenv init -|psub)

# Load GPG
set -gx GPG_TTY (tty)

source ~/.config/omf/abbreviations.fish
source ~/.config/omf/alias.fish
source ~/.config/omf/hooks.fish

set -gx LDFLAGS -L/usr/local/opt/openssl/lib
set -gx CPPFLAGS -I/usr/local/opt/openssl/include

# Set default java version
set -gx JAVA_HOME (/usr/libexec/java_home -v 1.8)

# Set location of tasks to OneDrive
set -gx TASKDATA ~/OneDrive/Tasks

# Load Direnv
eval (direnv hook fish)

# Load load untracked fish files in ./user folder
for filename in ~/.config/omf/user/*.fish
    source $filename
end

if test -f ~/.autojump/share/autojump/autojump.fish
    source ~/.autojump/share/autojump/autojump.fish
end
