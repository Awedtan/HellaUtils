#!/bin/bash
export PATH=$PATH:/home/daniel8su/.nvm/versions/node/v18.16.1/bin

CURRENTHEAD=$(git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD)
SAVEDHEAD=$(cat head)
if [[ ! $CURRENTHEAD = $SAVEDHEAD ]]; then
    git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD > head
    cd HellaAPI
    git fetch
    git merge
    node src/utils/loadDb.js >> ../log
    echo "$(date) - DB updated" >> ../log
    echo
    cd ..
fi

cd HellaBot

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [[ ! $LOCAL = $REMOTE ]]; then
    git merge
    npm ci
    sleep 5
    pm2 flush
    pm2 restart hellabot
    echo "$(date) - Bot updated" >> ../log
fi