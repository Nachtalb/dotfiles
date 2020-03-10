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

function vim-buildout
    mkdir -p .vim
    echo '{ "python.pythonPath": "'(pyenv which python)'" }' > .vim/coc-settings.json
end


function title
    set_color e91ec6 -o && printf "\n\n---> $argv <---\n\n" & set_color normal
end

function comment
    set_color aaa && echo "# $argv" & set_color normal
end

function run
    set_color e91ec6 && echo "\$ $argv" & set_color normal
    $argv
end


function psp
    title 'Setup plone environment'
    run pyenv deactivate
    run pyenv local new-plone-env
    set -l project_name (cat setup.py | grep name= | cut -d\' -f2)
    if not test -e development_nick.cfg
        or test "-f" = $argv[1]
        set -l action (test -e development_nick.cfg && echo 'Overriding' || echo 'Adding')
        title "$action development_nick.cfg"
        run cp "$SCRIPTS_ASSETS_PATH/development.cfg" development_nick.cfg
        run sed -i '' "s/PACKAGE_NAME/$project_name/g" development_nick.cfg
    end

    run ln -fs development_nick.cfg buildout.cfg
    title "Bootstrapping"
    run python bootstrap.py
    title "Buildouting"
    run bin/buildout
    title "Configure coc-vim"
    run vim-buildout
    run notify Finished "Plone Setup"
end

# function ftw
#     gh 4teamwork ftw.$argv[1]
# end
#
# function __ftw_repos
#   set -l path $GH_BASE_DIR/github.com/4teamwork/
#   test -d $path; and command ls -L $path | grep "ftw.*" --color=never | sort | uniq -du | sed 's/ftw.//g'
# end
#
# complete -c ftw --arguments '(__ftw_repos)' --no-files
