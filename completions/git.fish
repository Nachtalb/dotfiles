source /usr/share/fish/completions/git.fish
complete -f -c git -n __fish_git_needs_command -a tossh -d 'Swap HTTP remote with a SSH'
complete -f -c git -n __fish_git_needs_command -a tohttp -d 'Swap SSH remote with a HTTP one'

complete --no-files git -a '(__fish_git_remotes)' -n '__fish_git_using_command tossh'
complete --no-files git -a '(__fish_git_remotes)' -n '__fish_git_using_command tohttp'
