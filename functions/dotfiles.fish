function _echo  -a text -a silent_mode
    if not set -q "$silent_mode"; or test $silent_mode -eq 1; or not set -q $silent_mode
        echo $text >&2
    end
end

function _with_color
    set_color $argv[1]
    $argv[2..]
    set_color normal
end

function _dotfile_config
    set config_key $argv[2]
    set config_file ~/.config/fish/settings/$config_key

    contains -- -q $argv
    set silent_mode $status

    switch $argv[1]
        case "set"  # Set config
            if test (count $argv) = 3
                echo $argv[3] > $config_file
                if test $status -eq 0
                    _echo "Config $config_key updated." $silent_mode
                else
                    _echo "Failed to set config $config_key." $silent_mode
                    return 1
                end
            end

        case "get"  # Get config
            if test -f $config_file
                cat $config_file
            else
                _echo "Config $config_key does not exist yet." $silent_mode
                return 1
            end

        case "remove"  # Delete config
            if test -f $config_file
                rm $config_file
                if test $status -eq 0
                    _echo "Config $config_key deleted." $silent_mode
                else
                    _echo "Failed to delete config $config_key." $silent_mode
                    return 1
                end
            else
                _echo "Config $config_key already deleted." $silent_mode
            end

        case '*'
            _echo "Invalid option." $silent_mode
            return 1
    end
end

function _dotfile_update_ssh
    set config_public ~/.ssh/config.public
    set config_private ~/.ssh/config.private
    set config ~/.ssh/config

    if test -f $config_private
        cat $config_public $config_private > $config
    else
        cat $config_public > $config
    end

    chmod 600 $config
    and _echo "SSH config updated."
    or _echo "Failed to update SSH config."
end

function _dotfile_setup
    for file in ~/.config/fish/setup/*.fish
        source $file
        and _echo "Sourced $file"
        or _echo "Failed to source $file"
    end
end

function dotfiles
    switch $argv[1]
        case "config"
            _dotfile_config $argv[2..-1]
        case "update-ssh"
            _dotfile_update_ssh
        case "setup"
            _dotfile_setup
        case '*'
            _echo "Usage: dotfiles [config|update-ssh|setup] ..."
            return 1
    end
end
