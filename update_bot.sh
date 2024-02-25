#!/bin/bash
export PATH=$PATH:/home/daniel8su/.nvm/versions/node/v18.16.1/bin

cd HellaBot

git fetch
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    git merge
    npm ci
    sleep 5
    echo "$(date) - Start bot update - $REMOTE"
    pm2 flush
    pm2 restart hellabot
    echo "$(date) - Bot updated"
fi