# Load fish's own git completions first (embedded in the binary since fish 4)
if test -f /usr/share/fish/completions/git.fish
    source /usr/share/fish/completions/git.fish
else
    status get-file completions/git.fish | source
end

complete -f -c git -n __fish_git_needs_command -a tossh -d 'Swap HTTP remote with a SSH'
complete -f -c git -n __fish_git_needs_command -a tohttp -d 'Swap SSH remote with a HTTP one'

complete --no-files git -a '(__fish_git_remotes)' -n '__fish_git_using_command tossh'
complete --no-files git -a '(__fish_git_remotes)' -n '__fish_git_using_command tohttp'
