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

function read_confirm
  set -l question 'Do you want to continue?'
  if test "$argv"
      set question $argv
  end

  while true
    read -l -P "$question [y/N] " confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
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

function __fish_git_local_branches
    command git for-each-ref --format='%(refname)' refs/heads/ refs/remotes/ 2>/dev/null \
        | string replace -rf '^refs/heads/(.*)$' '$1\tLocal Branch'
end

function __fish_git_unique_remote_branches
    # `git checkout` accepts remote branches without the remote part
    # if they are unambiguous.
    # E.g. if only alice has a "frobulate" branch
    # `git checkout frobulate` is equivalent to `git checkout -b frobulate --track alice/frobulate`.
    command git for-each-ref --format="%(refname:strip=3)" \
        --sort="refname:strip=3" \
        "refs/remotes/*/$match*" "refs/remotes/*/*/**" 2>/dev/null | \
        uniq -u
end

function __fish_git_tags
    command git tag --sort=-creatordate 2>/dev/null
end


function s
    if not test "$argv"
        comment 'Back to parent'
        run cd (git config --get remote.parent.url | string replace -r '/.git$' '')
        return
    end

    set -l parent_dir (git rev-parse --show-toplevel)
    set -l sub_root ~/Development/subinstallations$parent_dir

    if test $argv[1] = '-l'
        ls -1 $sub_root 2>/dev/null
        return
    end

    if test $argv[1] = '-d'
        if test $argv[2]
            comment 'Removing ' $argv[2]
            run rm -rf $sub_root/$argv[2]
        else if read_confirm "Deleting all subinstallation?"
            run rm -rf $sub_root
        end
        return
    end

    set -l sub_dir $sub_root/$argv[1]

    if not test -d $sub_dir
        title "New Subinstallation"
        run mkdir -p $sub_dir
        run git clone (git config --get remote.origin.url) $sub_dir
        run cd $sub_dir
        run git remote add parent $parent_dir/.git
        run git fetch parent
        run git checkout $argv[1] 2>/dev/null
    else
        run cd $sub_dir
    end
end

complete -x -k -c s -s d -d "Local Subinstallation" -a "(s -l)"

complete -x -k -c s -d "Tag" -a "(__fish_git_tags)"
complete -x -k -c s -d "Unique Remote Branch" -a "(__fish_git_unique_remote_branches)"
complete -x -k -c s -d "Git Local Branch" -a "(__fish_git_local_branches)"
complete -x -k -c s -d "Local Subinstallation" -a "(s -l)"
