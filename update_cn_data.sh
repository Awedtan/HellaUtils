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

    REMOTE=$REMOTE DATE=$DATE ARK_FOLDER=$ARK_FOLDER scripts/update_cn_assets.sh
fi

rm "/tmp/cn"
