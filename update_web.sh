#!/bin/bash

if [ -e "/tmp/web" ]; then
    exit
else
    touch "/tmp/web"
fi

cd webserver

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start website update - $REMOTE"
    git restore .
    git merge
    echo "$(date) - Website updated"
    echo "======================="
fi

rm "/tmp/web"
