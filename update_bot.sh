#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

cd HellaBot

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start bot update - $REMOTE"
    git restore .
    git merge
    npm ci
    sleep 5
    pm2 flush
    pm2 restart hellabot
    echo "$(date) - Bot updated"
    echo
fi