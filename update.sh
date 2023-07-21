#!/bin/bash
export PATH=$PATH:/home/daniel8su/.nvm/versions/node/v18.16.1/bin

cd /home/daniel8su/HellaBot
bool=0
git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [ ! $LOCAL = $REMOTE ]; then
    git merge
    bool=1
    echo "$(date) - Bot updated" >> ../log
fi
cd ArknightsGameData
git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [ ! $LOCAL = $REMOTE ]; then
    git merge
    bool=1
    echo "$(date) - Game data updated" >> ../../log
fi
if [ "$bool" -eq 1 ]; then
    sleep 5
    pm2 flush
    pm2 restart hellabot >> ../../log
    echo "$(date) - Update completed" >> ../../log
fi
