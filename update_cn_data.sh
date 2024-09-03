#!/bin/bash
set -e

LOCAL=$(cat scripts/apk_url)
REMOTE=$(node scripts/get_apk_src.js | grep .apk | head -n 1 | sed -E 's/.+<a href="https:\/\/pkg\.bili/https:\/\/pkg\.bili/' | sed -E 's/\.apk.+/\.apk/')
DATE=$(date +"%Y-%m-%d")
FOLDER=~/arknights/$DATE

if [[ $LOCAL != $REMOTE ]]; then
    echo "$(date) - Start CN data update - $REMOTE"
    echo $REMOTE > "scripts/apk_url"
    mkdir -p $FOLDER

    wget $REMOTE -O $FOLDER/arknights.apk

    # if [ ! -d "$HOME/.android/avd/arknights.avd" ]; then
    sdkmanager platform-tools emulator "platforms;android-24" "system-images;android-24;google_apis;x86_64"
    echo n | avdmanager create avd -f -n arknights -k "system-images;android-24;google_apis;x86_64"
    cat ~/.android/avd/arknights.avd/config.ini | sed 's/disk.dataPartition.size=800M/disk.dataPartition.size=16G/' | tee ~/.android/avd/arknights.avd/config.ini
    # fi

    emulator -avd arknights -no-window -wipe-data &>/dev/null & disown

    echo 'Waiting for device'
    adb wait-for-device
    echo 'Waiting 3 mins'
    sleep 180
    adb root
    echo 'Pushing apk'
    adb push $FOLDER/arknights.apk /data/
    echo 'Installing apk'
    adb shell pm install /data/arknights.apk
    sleep 15
    echo 'Starting app'
    adb shell monkey -p com.hypergryph.arknights.bilibili 1
    sleep 15
    echo 'Tap 1'
    adb shell input tap 400 230
    sleep 30
    echo 'Tap 2'
    adb shell input tap 375 290
    sleep 10
    echo 'Tap 3'
    adb shell input tap 375 200
    sleep 5
    echo 'Tap 4'
    adb shell input tap 320 270
    sleep 5
    echo 'Tap 5'
    adb shell input tap 450 220
    echo 'Waiting 30 secs'
    sleep 30
    echo 'Waiting for HGDownload'
    adb shell 'while [ $(du -s /storage/emulated/0/Android/data/com.hypergryph.arknights.bilibili/files/HGDownload | cut -f1) -ge 24 ]; do sleep 5; done;'
    echo 'Waiting 30 secs'
    sleep 30
    echo 'Tap 6'
    adb shell input tap 320 100
    echo 'Tap 7'
    adb shell input tap 320 215
    echo 'Tap 8'
    adb shell input tap 320 215
    sleep 10

    echo 'Pull files'
    adb pull /storage/emulated/0/Android/data/com.hypergryph.arknights.bilibili/files/AB/Android $FOLDER

    adb emu kill

    mkdir $FOLDER/apk
    unzip -q $FOLDER/arknights.apk -d $FOLDER/apk

    echo "$(date) - CN data updated"
    echo "$(date) - Start CN assets update - $REMOTE"

    # python3 -m venv venv
    # venv/bin/pip install unitypy numpy

    mkdir -p $FOLDER/assets/sandboxstages $FOLDER/extracted/sandboxstages
    mkdir $FOLDER/assets/sandboxitems $FOLDER/extracted/sandboxitems
    mkdir $FOLDER/assets/rogueitems $FOLDER/extracted/rogueitems
    mkdir $FOLDER/assets/skingroups $FOLDER/extracted/skingroups
    mkdir -p $FOLDER/assets/spine/operator $FOLDER/extracted/spine/operator
    mkdir $FOLDER/assets/spine/enemy $FOLDER/extracted/spine/enemy
    mkdir $FOLDER/assets/stages $FOLDER/extracted/stages

    cp -f $FOLDER/Android/spritepack/sandbox*.ab $FOLDER/assets/sandboxstages
    AssetStudioModCLI $FOLDER/assets/sandboxstages -t sprite -g none --log-level warning -o $FOLDER/extracted/sandboxstages

    cp -f $FOLDER/Android/spritepack/ui_roguelike*.ab $FOLDER/assets/rogueitems
    AssetStudioModCLI $FOLDER/assets/rogueitems -t sprite -g none --log-level warning -o $FOLDER/extracted/rogueitems

    cp -f $FOLDER/apk/assets/AB/Android/ui/skin_groups.ab $FOLDER/assets/skingroups
    AssetStudioModCLI $FOLDER/assets/skingroups -t sprite -g none --log-level warning -o $FOLDER/extracted/skingroups
    cd $FOLDER/extracted/skingroups
    # remove 'year#' at start of filenames
    for file in *.png; do
        if [[ "$file" =~ ^[0-9]{4}#(.*) ]]; then
            mv "$file" "${BASH_REMATCH[1]}"
        fi
    done
    # remove '#number' at end of filenames
    for file in *.png; do
        if [[ "$file" =~ ^(.*)#([0-9]+)\.png$ ]]; then
            mv "$file" "${BASH_REMATCH[1]}.png"
        fi
    done
    # remove all '_deco' files
    find . -name "*_deco.png" -type f -exec rm -f {} \;
    cd

    cp -f $FOLDER/apk/assets/AB/Android/chararts/char*.ab $FOLDER/assets/spine/operator
    cp -f $FOLDER/Android/chararts/char*.ab $FOLDER/assets/spine/operator
    arknights/venv/bin/python3 scripts/charspine.py $FOLDER/assets/spine/operator $FOLDER/extracted/spine/operator
    echo 'Exported operator spine assets'

    cp -f $FOLDER/apk/assets/AB/Android/battle/prefabs/enemies/enemy*.ab $FOLDER/assets/spine/enemy
    cp -f $FOLDER/Android/battle/prefabs/enemies/enemy*.ab $FOLDER/assets/spine/enemy
    AssetStudioModCLI $FOLDER/assets/spine/enemy -t tex2d,textAsset -g none --log-level warning -o $FOLDER/extracted/spine/enemy
    arknights/venv/bin/python3 scripts/enemyspine.py $FOLDER/extracted/spine/enemy

    cp -f $FOLDER/apk/assets/AB/Android/arts/ui/stage_mappreview*.ab $FOLDER/assets/stages
    cp -f $FOLDER/Android/arts/ui/stage_mappreview*.ab $FOLDER/assets/stages
    AssetStudioModCLI $FOLDER/assets/stages -t sprite -g none --log-level warning -o $FOLDER/extracted/stages

    cp -f $FOLDER/Android/ui/sandboxperm/[uc]common.ab $FOLDER/assets/sandboxitems
    AssetStudioModCLI $FOLDER/assets/sandboxitems --filter-by-text itemicon -t sprite -g none --log-level warning -o $FOLDER/extracted/sandboxitems

    cp -f $FOLDER/Android/ui/sandboxv2/topics/[uc]sandbox_1.ab $FOLDER/assets/sandboxweather
    AssetStudioModCLI $FOLDER/assets/sandboxweather --filter-by-text weathertypeicons -t sprite -g none --log-level warning -o $FOLDER/extracted/sandboxweather

    BRANCH=cn-$DATE
    cd HellaAssets
    git switch main
    git fetch
    git reset --hard
    git pull
    git checkout -b $BRANCH

    cp -r $FOLDER/extracted/* .
    git add .
    git commit -m "[$DATE] Automated commit"
    git push --set-upstream origin $BRANCH
    gh pr create --title "[$DATE] Automated PR" --body "CN update for $DATE" --head "$BRANCH" --base "main"

    git switch main
    git branch -D $BRANCH

    echo "$(date) - CN assets updated"
    echo "======================="
fi
