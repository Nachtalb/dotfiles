set -g SCRIPTS_ASSETS_PATH (dirname (status --current-filename))/assets

function tmux-4
    # Open a 2 by 2 tmux window
    tmux new-session $argv \; \
            split-window -v \; \
            split-window -h \; \
            select-pane -t 0 \; \
            split-window -h -b \;
end

function always-on
    # Open tmux 'always-on' or create it and auto run all necessary functions
    if tmux has-session -t always-on
        if echo $TMUX
            tmux switch-client -t always-on
            return
        end
        tmux a -t always-on
        return
    end

    set -ul TMUX
    tmux new-session -s always-on -c '/Users/bernd/Development/local-always-on-sites' \; \
        split-window -v \; \
        send-key 'cd bgbern.ng && bin/solr-instance fg' C-m \; \
        split-window -v \; \
        send-key 'cd bumblebee && ssh bumblebee' C-m \; \
        split-window -h \; \
        send-key 'cd bumblebee && bin/pdftools/shares mount && foreman start; bin/pdftools/shares umount' C-m \; \
        select-pane -t 1 \; \
        split-window -h \; \
        send-key 'cd bgbern.ng && bin/tika-server start' C-m \; \
        select-pane -t 0 \; \
        split-window -h \; \
        send-key 'sudo running-sites' C-m \; \
        select-pane -t 0 \;
end

function junk
    # Move files to Mac Trash instead of deleting them completely
    for item in $argv
        echo "Trashing: $item"
        mv "$item" ~/.Trash/
    end
end

function tmux-terminal-color
    if set -q TMUX
            set -gx TERM screen-256color
    end
end

function psp
    pyenv local new-plone-env
    cp "$SCRIPTS_ASSETS_PATH/development.cfg" development_nick.cfg
    ln -fs development_nick.cfg buildout.cfg
    python bootstrap.py
    bin/buildout
end
