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
    if tmux ls | grep 'always-on'
        tmux a -t always-on
        return
    end

    tmux server
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
        send-key 'htop' C-m \; \
        split-window -v -p 25 \; \
        send-key 'sudo running-sites' C-m \; \
        select-pane -t 0 \;
end
