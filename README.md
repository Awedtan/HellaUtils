# how 2 mine for ~~gold~~ assets

https://github.com/aelurum/AssetStudio/tree/ArknightsStudio

https://github.com/isHarryh/Ark-Unpacker

## locations
- char spine: `*/chararts/*.ab`
- char skin spines: `Android/skinpack/*.ab`
- char full arts: `*/chararts/*.ab`
- char avatars: `*/spritepack/ui_char_avatar_*.ab`
- char skills: `APK/spritepack/skill_icons_*.ab`
- char modules: `*/spritepack/ui_equip_big_img_hub_13.ab`
- char base skills: `*/spritepack/building_ui_buff_skills_h1_0.ab`
- enemy spine: `APK/battle/prefabs/enemies`
- rogue items: `Android/spritepack/*.ab`
- sandbox stage previews: `Android/spritepack/*.ab`
- skin groups: `APK/ui/skin_groups.ab`
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
