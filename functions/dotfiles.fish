function _is_silent
  if not set -q "$silent_mode"; or test $silent_mode -eq 1; or not set -q $silent_mode
    return 1
  end
end

function _echo  -a text -a silent_mode
    if not _is_silent
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

function _dotfile_merge_ssh
    # Merge SSH config
    # Merge ~/.ssh/config.public and ~/.ssh/config.private into ~/.ssh/config
    set config_public ~/.ssh/config.public
    set config_private ~/.ssh/config.private
    set config ~/.ssh/config

    if not test -f $config_public
      set_color --bold red
      echo "SSH config public file does not exist."
      set_color normal
      return 1
    end

    # Ask if file is good colored
    _echo "Merged SSH config:"
    _echo "----------------------------------------"
    cat $config_public $config_private | bat -l "SSH Config" -p
    _echo "----------------------------------------"

    # Retrieve user input to continue, default to yes
    if not _is_silent
      read -P 'Is this good? [Y/n]: ' -n 1 REPLY

      set_color --bold red
      if test $status -eq 0
        if test $REPLY = "n"
          echo "Aborted."
          return 1
        end
      else
        echo "Aborted."
        return 1
      end
      set_color normal
    end


    if test -f $config
      _echo "Backing up existing SSH config to $config.bak"
      cp $config $config.bak
    end

    if test -f $config_private
        cat $config_public $config_private > $config
    else
        cat $config_public > $config
    end

  chmod 600 $config
  and _echo "SSH config merged"
    or _echo "Failed to merge SSH config."
end

function _dotfile_setup
    # Source setup scripts in ~/.config/fish/setup directory in alphabetical order
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
        case "merge-ssh"
            _dotfile_merge_ssh
        case "setup"
            _dotfile_setup
        case '*'
            _echo "Usage: dotfiles [config|merge-ssh|setup] ...

    config:       Manage dotfiles settings
    merge-ssh:    Merge public and private SSH config files into ~/.ssh/config
    setup:        Run setup scripts in ~/.config/fish/setup directory
    "
            return 1
    end
end
