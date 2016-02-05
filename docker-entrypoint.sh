#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- gollum "$@"
fi

if [ "$1" = 'gollum' ]
then
    OPTIONS="/gollum/wiki $@"
    
    if [ "$GOLLUM_BARE" == "true" ]
    then
        if [ ! -d /gollum/wiki.git/objects ]
        then
            mkdir -p /gollum/wiki.git
            cd /gollum/wiki.git
            echo 'INFO: creating bare git repository in /gollum/wiki.git'
            git init --bare
        fi
        OPTIONS="/gollum/wiki.git --bare $@"
        chown -R gollum.gollum /gollum/wiki.git
    else
        if [ ! -d /gollum/wiki/.git ]
        then
            mkdir -p /gollum/wiki
            cd /gollum/wiki
            echo 'INFO: creating git repository in /gollum/wiki'
            git init
        fi
        if [ -f /gollum/wiki/custom.css ]
        then
            OPTIONS="$OPTIONS --css"
        fi
        chown -R gollum.gollum /gollum/wiki
    fi

    echo 'INFO: Starting gollum ...'
    exec /usr/local/bin/gosu gollum:gollum /usr/bin/gollum $OPTIONS
fi

exec "$@"
