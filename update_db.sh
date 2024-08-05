#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

if [ -e "/tmp/db" ]; then
    exit
else
    touch "/tmp/db"
fi

LOCAL=$(cat "scripts/yostar_head" | awk '{print $1}')
REMOTE=$(git ls-remote "https://github.com/Kengxxiao/ArknightsGameData_YoStar.git" HEAD | awk '{print $1}')
if [[ $LOCAL != $REMOTE ]]; then
    echo "$(date) - Start DB update - $REMOTE"
    echo $REMOTE > "scripts/yostar_head"
    cd HellaAPI/ArknightsGameData_YoStar
    git fetch
    git checkout main
    git merge
    cd ..
    sleep 5
    npm run load
    echo "$(date) - DB updated"
    echo "======================="
fi

rm "/tmp/db"
