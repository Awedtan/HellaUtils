#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

if [ -e "/tmp/bot" ]; then
    exit
else
    touch "/tmp/bot"
fi

cd HellaBot

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start bot update - $REMOTE"
    git reset --hard
    git merge
    npm ci
    sleep 5
    pm2 flush hellabot
    pm2 restart hellabot
    echo "$(date) - Bot updated"
    echo "======================="
fi

rm "/tmp/bot"
