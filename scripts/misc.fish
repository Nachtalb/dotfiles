set -g SCRIPTS_ASSETS_PATH (dirname (status --current-filename))/assets

function junk
    # Move files to Mac Trash instead of deleting them completely
    for item in $argv
        echo "Trashing: $item"
        mv "$item" ~/.Trash/
    end
end

function psp
    pyenv local new-plone-env
    cp "$SCRIPTS_ASSETS_PATH/development.cfg" development_nachtalb.cfg
    ln -fs development_nachtalb.cfg buildout.cfg
    python bootstrap.py
    bin/buildout
end
