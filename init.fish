
# Initialize the current fish session and connect to the tmux session.
set TIME_START (date +%s%3N)
# If we're not running in an interactive terminal, do nothing.
function start-tmux
    if begin; not isatty; or not status --is-interactive; or test -n "$INSIDE_EMACS"; or set -q NOTMUX; end
      echo 'notmux'
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
end
#start-tmux
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
set -gx JAVA_HOME (readlink -f /usr/bin/javac | sed "s:/bin/javac::")
set -gx PYTHON_CONFIGURE_OPTS "--enable-shared"

# Expand $PATH
set -gx PATH $PATH $HOME/.vim/plugged/vim-superman/bin
set -gx PATH $PATH /usr/local/opt/mysql-client@5.7/bin
set -gx PATH $PATH /usr/local/opt/qt/bin
set -gx PATH $PATH $HOME/.yarn/bin
set -gx PATH $HOME/bin/ $PATH
set -gx PATH $PATH $HOME/.config/omf/bin

# Lang setting
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Use vim as default editor
set -gx VISUAL vim
set -gx EDITOR $VISUAL

# GH config
set -gx GH_BASE_DIR $HOME/src
set -gx GL_BASE_DIR $HOME/src
set -gx GB_BASE_DIR $HOME/src

# Add etcher-cli if available
if test -d /opt/etcher-cli
    set -gx PATH /opt/etcher-cli $PATH
end

# set winhost
set -l winhost (cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
if not grep -P $winhost"[[:space:]]winhost" /etc/hosts -q
    if grep -P "[[:space:]]winhost" /etc/hosts -q
        sudo sed -i '/winhost/d' /etc/hosts
    end

    printf "%s\t%s\n" "$winhost" "winhost" | sudo tee -a /etc/hosts
    echo 'winhost updated'
end


###############################################################################
# Load tools                                                                  #
###############################################################################

# Own configurations
source ~/.config/omf/abbreviations.fish
source ~/.config/omf/alias.fish
source ~/.config/omf/hooks.fish

if status is-interactive
    # Pyenv
    # source (pyenv init - --no-rehash|psub)
    source (pyenv virtualenv-init -|psub)

    # Rbevn
    # source (rbenv init -|psub)
end

# direnv
# eval (direnv hook fish)

# Git ignored files
for filename in ~/.config/omf/user/*.fish
    source $filename
end

# Own scripts
for file in ~/.config/omf/scripts/*.fish
    source $file
end

# Autojump
    source ~/.autojump/share/autojump/autojump.fish
    if test -f ~/.autojump/share/autojump/autojump.fish
end
set TIME_END (date +%s%3N)

echo "It took:" (expr $TIME_END - $TIME_START) "ms to load the environment"
