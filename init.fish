# Initialize the current fish session and connect to the tmux session.
# set TIME_TOT_START (date +%s%3N)

function start-tmux
    # If we're not running in an interactive terminal, do nothing.
    if begin; not isatty; or not status --is-interactive; or test -n "$INSIDE_EMACS"; or set -q NOTMUX; end
      exit
    end

    # Connect to the TMUX session if it exists, or create it if it doesn't.
    if not set -q TMUX
      set -l session_name local
      if tmux has-session -t $session_name 2> /dev/null
        exec env -- tmux new-session -t $session_name \; set destroy-unattached on
      else
        exec env -- tmux new-session -s $session_name
      end
      exit
    end
end
start-tmux
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
set -gx GO111MODULE on

# Expand $PATH
set -l NewPaths /opt/etcher-cli \
                /usr/local/go/bin \
                $HOME/.vim/plugged/vim-superman/bin \
                $HOME/.yarn/bin \
                $HOME/.cargo/bin \
                $HOME/.config/omf/bin \
                $HOME/bin/

for p in $NewPaths
    if test -d $p
        fish_add_path $p
    end
end

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


# set winhost
# if not rg -q winhost /etc/hosts
    # set -l winhost (cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
    # if not grep -P $winhost"[[:space:]]winhost" /etc/hosts -q
        # if grep -P "[[:space:]]winhost" /etc/hosts -q
            # sudo sed -i '/winhost/d' /etc/hosts
        # end
#
        # printf "%s\t%s\n" "$winhost" "winhost" | sudo tee -a /etc/hosts
        # echo 'winhost updated'
    # end
# end


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
for file in ~/.config/omf/user/*.fish ~/.config/omf/scripts/*.fish
    source $file
end

# Autojump
    source ~/.autojump/share/autojump/autojump.fish
    if test -f ~/.autojump/share/autojump/autojump.fish
end

# echo "Total:" (expr (date +%s%3N) - $TIME_TOT_START) "ms"
