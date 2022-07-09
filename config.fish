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

# Expand $PATH
set -l NewPaths \
    /usr/local/go/bin \
    $HOME/.yarn/bin \
    $HOME/.cargo/bin \
    $HOME/.config/fish/bin
    $HOME/bin/

for p in $NewPaths
    if test -d $p
        fish_add_path $p
    end
end

# Use vim as default editor
set -gx VISUAL nvim
set -gx EDITOR $VISUAL

for p in /usr/bin/{chromium,microsoft-edge,microsoft-edge-dev}
    if test -f $p
        set -gx BROWSER
    end
end

# GH config
set -gx GH_BASE_DIR $HOME/src
set -gx GL_BASE_DIR $HOME/src
set -gx GB_BASE_DIR $HOME/src
