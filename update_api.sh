#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

if [ -e "/tmp/api" ]; then
    exit
else
    touch "/tmp/api"
fi

cd HellaAPI

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start API update - $REMOTE"
    git reset --hard
    git merge
    npm i
    sleep 5
    pm2 flush hellaapi
    pm2 restart hellaapi
    echo "$(date) - API updated"
    echo "======================="
fi

rm "/tmp/api"
