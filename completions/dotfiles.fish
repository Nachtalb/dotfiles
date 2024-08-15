# Merge SSH subcommand
complete -c dotfiles -n "__fish_seen_subcommand_from merge-ssh" -f

# Setup subcommand
complete -c dotfiles -n "__fish_seen_subcommand_from setup" -f

# Config subcommand
complete -c dotfiles -n "__fish_seen_subcommand_from config" -a "set get remove" -d "Config actions" -x
complete -c dotfiles -n "__fish_seen_subcommand_from config" -a "-q" -d "Silent mode" -f
complete -c dotfiles -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from set" -a "(/usr/bin/ls -1 ~/.config/fish/settings/)" -d "Config key" -x
complete -c dotfiles -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from get" -a "(/usr/bin/ls -1 ~/.config/fish/settings/)" -d "Config key" -x
complete -c dotfiles -n "__fish_seen_subcommand_from config; and __fish_seen_subcommand_from remove" -a "(/usr/bin/ls -1 ~/.config/fish/settings/)" -d "Config key" -x

# Main command
complete -c dotfiles -s h -l help -d "Show help"
complete -c dotfiles -n "__fish_use_subcommand" -a "config" -f -d "Get or set configuration values"
complete -c dotfiles -n "__fish_use_subcommand" -a "merge-ssh" -f -d "Merge SSH configurations"
complete -c dotfiles -n "__fish_use_subcommand" -a "setup" -f -d "Run setup scripts"
