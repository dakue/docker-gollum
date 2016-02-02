#!/bin/bash
set -e

if [ "$1" = 'gollum' ]
then
    mkdir -p /gollum/wiki.git
    cd /gollum/wiki.git
    git init --bare
    chown -R gollum.gollum /gollum/wiki.git
    exec /usr/local/bin/gosu gollum /usr/bin/gollum --gollum-path /gollum/wiki.git --bare
fi

exec "$@"
