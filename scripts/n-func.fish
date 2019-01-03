#!/usr/local/bin/fish

set -gx NCOPY ~/.ncopy
set -gx NMOVE ~/.ncopy

function ncc --description "Mark file to copy, paste with `ncp`" --a show
    if test -n $show
        if test $show = '--show'
            cat $NCOPY
            return
        end
    end
    echo (realpath $argv[1]) > $NCOPY
end

function ncp --description "Paste the file marked for copying (`ncc` command)" --a path
    if test -z $path
        set path .
    end
    cp (cat $NCOPY) $path $argv[2..-1]
    echo 'File was copied from "'(cat $NCOPY)'" to "'(realpath $path)'"'
end

function nmc --description "Mark file for movement, move with `nmp`" --a show
    if test -n $show
         if test $show = '--show'
            cat $NMOVE
            return
        end
    end
    echo (realpath $argv[1]) > $NMOVE
end

function nmp --description "Move file marked for moevement (`nmc` command)" --a path
    if test -z $path
        set path .
    end
    mv (cat $NMOVE) $path $argv[2..-1]
    echo 'File was moved from "'(cat $NMOVE)'" to "'(realpath $path)'"'
end
