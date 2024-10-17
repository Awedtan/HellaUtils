#!/bin/bash
set -e

if [ -e "/tmp/cn" ]; then
    exit
else
    touch "/tmp/cn"
fi

LOCAL=$(cat scripts/apk_url)
REMOTE=$(node scripts/get_apk_src.js | grep .apk | head -n 1 | sed -E 's/.+<a href="https:\/\/pkg\.bili/https:\/\/pkg\.bili/' | sed -E 's/\.apk.+/\.apk/')
DATE=$(date +"%Y-%m-%d")
ARK_FOLDER=~/arknights/$DATE

if [[ $LOCAL != $REMOTE ]]; then
    echo "$(date) - Start CN data update - $REMOTE"
    echo $REMOTE > "scripts/apk_url"
    mkdir -p $ARK_FOLDER

    wget $REMOTE -O $ARK_FOLDER/arknights.apk

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
    adb push $ARK_FOLDER/arknights.apk /data/
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
    adb pull /storage/emulated/0/Android/data/com.hypergryph.arknights.bilibili/files/AB/Android $ARK_FOLDER

    adb emu kill

    mkdir $ARK_FOLDER/apk
    unzip -q $ARK_FOLDER/arknights.apk -d $ARK_FOLDER/apk

    echo "$(date) - CN data updated"
    echo "$(date) - Start CN assets update - $REMOTE"

    # python3 -m venv venv
    # venv/bin/pip install unitypy numpy

    FILES=Android/chararts/*.ab
    FOLDER=operator/arts
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text characters -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/operator/arts

    FILES=Android/spritepack/ui_char_avatar_*.ab
    FOLDER=operator/avatars
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text char_ -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/spritepack/building_ui_buff_skills_h1_0.ab
    FOLDER=operator/bases
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text bskill -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/spritepack/ui_equip_big_img_hub_*.ab
    FOLDER=operator/modules
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text uniequip -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/spritepack/skill_icons_*.ab
    FOLDER=operator/skills
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text skill_icon -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/spritepack/ui_roguelike*.ab
    FOLDER=rogue/items
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/ui/sandboxperm/[uc]common.ab
    FOLDER=sandbox/items
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text itemicon -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/spritepack/sandbox*.ab
    FOLDER=sandbox/stages
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/ui/sandboxv2/topics/[uc]sandbox_1.ab
    FOLDER=sandbox/weather
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER --filter-by-text weathertypeicons -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/ui/skin_groups.ab
    FOLDER=skingroups
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER
    cd $ARK_FOLDER/extracted/$FOLDER
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

    FILES=Android/battle/prefabs/enemies/enemy*.ab
    FOLDER=spine/enemy
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER -t tex2d,textAsset -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER
    ~/arknights/venv/bin/python3 ~/scripts/enemyspine.py $ARK_FOLDER/extracted/$FOLDER

    FILES=Android/chararts/char*.ab
    FOLDER=spine/operator
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ~/arknights/venv/bin/python3 ~/scripts/charspine.py $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    echo 'Exported operator spine assets'

    FILES=Android/arts/ui/stage_mappreview*.ab
    FOLDER=stages
    mkdir -p $ARK_FOLDER/assets/$FOLDER $ARK_FOLDER/extracted/$FOLDER
    cp -f $ARK_FOLDER/apk/assets/AB/$FILES $ARK_FOLDER/assets/$FOLDER
    cp -f $ARK_FOLDER/$FILES $ARK_FOLDER/assets/$FOLDER
    ArknightsStudioCLI $ARK_FOLDER/assets/$FOLDER -t sprite -g none --log-level warning -o $ARK_FOLDER/extracted/$FOLDER

    cd ~/HellaAssets
    git switch main
    git add .
    git reset --hard
    git pull

    BRANCH=cn-$DATE-operator
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/operator .
    git add operator
    git commit -m "[$DATE] Automated PR - Operator" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Operator" --body "CN update for $DATE" --head "$BRANCH" --base "main"

    BRANCH=cn-$DATE-rogue
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/rogue .
    git add rogue
    git commit -m "[$DATE] Automated PR - Rogue" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Rogue" --body "CN update for $DATE" --head "$BRANCH" --base "main"

    BRANCH=cn-$DATE-sandbox
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/sandbox .
    git add sandbox
    git commit -m "[$DATE] Automated PR - Sandbox" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Sandbox" --body "CN update for $DATE" --head "$BRANCH" --base "main"

    BRANCH=cn-$DATE-skingroups
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/skingroups .
    git add skingroups
    git commit -m "[$DATE] Automated PR - Skingroup" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Skingroup" --body "CN update for $DATE" --head "$BRANCH" --base "main" --label "skingroup"

    BRANCH=cn-$DATE-spine
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/spine .
    git add spine
    git commit -m "[$DATE] Automated PR - Spine" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Spine" --body "CN update for $DATE" --head "$BRANCH" --base "main" --label "spine"

    BRANCH=cn-$DATE-stages
    git switch main
    git checkout -b $BRANCH
    cp -r $ARK_FOLDER/extracted/stages .
    git add stages
    git commit -m "[$DATE] Automated PR - Stage" && \
    git push --set-upstream origin $BRANCH && \
    gh pr create --title "[$DATE] Automated PR - Stage" --body "CN update for $DATE" --head "$BRANCH" --base "main" --label "stage"

    git switch main

    echo "$(date) - CN assets updated"
    echo "======================="
fi

rm "/tmp/cn"
