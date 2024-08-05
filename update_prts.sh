#!/bin/bash

if [ -e "/tmp/prts" ]; then
    exit
else
    touch "/tmp/prts"
fi

cd stage-viewer

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start PRTS update - $REMOTE"
    git restore .
    git merge
    echo "$(date) - PRTS updated"
    echo "======================="
fi

rm "/tmp/prts"
