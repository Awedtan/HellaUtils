# how 2 mine for ~~gold~~ assets

https://github.com/aelurum/AssetStudio/tree/ArknightsStudio
https://github.com/isHarryh/Ark-Unpacker

## locations
- rogue items: `Android/spritepack/*.ab`
- skin groups: `APK/ui/skin_groups.ab`
- char spine: `Android/chararts/*.ab`
- enemy spine: `APK/battle/prefabs/enemies`
- stage previews: `*/arts/ui/*.ab`

## how 2 get stage preview images
2. extract all stage images from both APK and Android
3. resize to 960x540 stretch
4. done!

## how 2 get enemy spine assets
2. extract all enemy Texture2D and TextAsset files
3. run enemyspine.py in parent directory
4. run ArkUnpacker option 3
5. copy/paste combined assets into folder
6. done!

## how 2 get char spine assets
1. get all chararts files in one folder
2. run charspine.py
3. run ArkUnpacker option 3
4. copy/paste combined assets into folder
5. done!

# Stuff to remember
```
ssh -i C:\Users\danie\.ssh\KEYS daniel8su@address
chmod +x setup.sh
pm2 start hellabot.sh
pm2 logs hellabot
pm2 flush hellabot
crontab -e
tail -f log.txt
git reset --hard

count files in folders:
find . -type d -exec bash -c "echo -ne '{} '; ls '{}' | wc -l" \;
```

# Sample db load
```
61 Archetypes loaded in 0.158s
408 Base skills loaded in 0.351s
28 CC stages loaded in 3.028s
79 Definitions loaded in 0.143s
668 Enemies loaded in 1.966s
112 Events loaded in 0.29s
679 Items loaded in 1.6s
294 Modules loaded in 0.926s
275 Operators loaded in 1.686s
127 Paradoxes loaded in 20.123s
56 Ranges loaded in 0.254s
2 Rogue themes loaded in 30.106s
683 Skills loaded in 2.319s
417 Skins loaded in 0.746s
2211 Stages loaded in 267.129s
Finished loading data in 334.325s
```