set -g SCRIPTS_ASSETS_PATH (dirname (status --current-filename))/assets

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

function ptest
    bin/test $argv && notify Finished Tests || notify Failed Tests
end

function junk
    # Move files to Mac Trash instead of deleting them completely
    for item in $argv
        echo "Trashing: $item"
        mv "$item" ~/.Trash/
    end
end

function psp
    pyenv local new-plone-env
    if not test -e development_nick.cfg
        or test "-f" = $argv[1]
        cp "$SCRIPTS_ASSETS_PATH/development.cfg" development_nick.cfg
    else
        echo "development_nick.cfg already exists if you want it replaced use -f"
    end

    ln -fs development_nick.cfg buildout.cfg
    python bootstrap.py
    bin/buildout
    notify Finished "Plone Setup"
end
