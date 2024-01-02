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