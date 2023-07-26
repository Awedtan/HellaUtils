#!/bin/bash
export PATH=$PATH:/home/daniel8su/.nvm/versions/node/v18.16.1/bin

CURRENTHEAD=$(git ls-remote https://github.com/Kengxxiao/ArknightsGameData.git HEAD)
SAVEDHEAD=$(cat head)
if [[ ! $CURRENTHEAD = $SAVEDHEAD ]]; then
    git ls-remote https://github.com/Kengxxiao/ArknightsGameData.git HEAD > head
    cd HellaAPI
    node src/loadDb.js >> ../log
    echo "$(date) - DB updated" >> ../log
    cd ..
fi

cd HellaBot

bool=0
git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [[ ! $LOCAL = $REMOTE ]]; then
    git merge
    bool=1
    echo "$(date) - Bot updated" >> ../log
fi
if [ "$bool" -eq 1 ]; then
    sleep 5
    pm2 flush
    pm2 restart hellabot >> ../log
    echo "$(date) - Bot restarted" >> ../log
fi