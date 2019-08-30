# fish completions for "git p"
# Copied "git push" completions and repalced "push" with "p"
# https://github.com/fish-shell/fish-shell/blob/225b1204d6928b484335917af8fbfb0de20e6f90/share/completions/git.fish#L1361-L1386
### push
complete -f -c git -n '__fish_git_needs_command' -a push -d 'Update remote refs along with associated objects'
complete -f -c git -n '__fish_git_using_command p; and not __fish_git_branch_for_remote' -a '(__fish_git_remotes)' -d 'Remote alias'
complete -f -c git -n '__fish_git_using_command p; and __fish_git_branch_for_remote' -a '(__fish_git_branches)'
# The "refspec" here is an optional "+" to signify a force-push
complete -f -c git -n '__fish_git_using_command p; and __fish_git_branch_for_remote; and string match -q "+*" -- (commandline -ct)' -a '+(__fish_git_branches | string replace -r \t".*" "")' -d 'Force-push branch'
# git push REMOTE :BRANCH deletes BRANCH on remote REMOTE
complete -f -c git -n '__fish_git_using_command p; and __fish_git_branch_for_remote; and string match -q ":*" -- (commandline -ct)' -a ':(__fish_git_branch_for_remote | string replace -r \t".*" "")' -d 'Delete remote branch'
# then src:dest (where both src and dest are git objects, so we want to complete branches)
complete -f -c git -n '__fish_git_using_command p; and __fish_git_branch_for_remote; and string match -q "+*:*" -- (commandline -ct)' -a '+(__fish_git_branches | string replace -r \t".*" ""):(__fish_git_branch_for_remote | string replace -r \t".*" "")' -d 'Force-push local branch to remote branch'
complete -f -c git -n '__fish_git_using_command p; and __fish_git_branch_for_remote; and string match -q "*:*" -- (commandline -ct)' -a '(__fish_git_branches | string replace -r \t".*" ""):(__fish_git_branch_for_remote | string replace -r \t".*" "")' -d 'Push local branch to remote branch'
complete -f -c git -n '__fish_git_using_command p' -l all -d 'Push all refs under refs/heads/'
complete -f -c git -n '__fish_git_using_command p' -l prune -d "Remove remote branches that don't have a local counterpart"
complete -f -c git -n '__fish_git_using_command p' -l mirror -d 'Push all refs under refs/'
complete -f -c git -n '__fish_git_using_command p' -l delete -d 'Delete all listed refs from the remote repository'
complete -f -c git -n '__fish_git_using_command p' -l tags -d 'Push all refs under refs/tags'
complete -f -c git -n '__fish_git_using_command p' -l follow-tags -d 'Push all usual refs plus the ones under refs/tags'
complete -f -c git -n '__fish_git_using_command p' -s n -l dry-run -d 'Do everything except actually send the updates'
complete -f -c git -n '__fish_git_using_command p' -l porcelain -d 'Produce machine-readable output'
complete -f -c git -n '__fish_git_using_command p' -s f -l force -d 'Force update of remote refs'
complete -f -c git -n '__fish_git_using_command p' -s f -l force-with-lease -d 'Force update of remote refs, stopping if other\'s changes would be overwritten'
complete -f -c git -n '__fish_git_using_command p' -s u -l set-upstream -d 'Add upstream (tracking) reference'
complete -f -c git -n '__fish_git_using_command p' -s q -l quiet -d 'Be quiet'
complete -f -c git -n '__fish_git_using_command p' -s v -l verbose -d 'Be verbose'
complete -f -c git -n '__fish_git_using_command p' -l progress -d 'Force progress status'
# TODO --recurse-submodules=check|on-demand
