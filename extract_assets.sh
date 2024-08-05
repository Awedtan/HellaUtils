#!/bin/bash

cd $FOLDER
mkdir -p assets/sandboxstages extracted/sandboxstages
mkdir assets/rogueitems extracted/rogueitems
mkdir assets/skingroups extracted/skingroups
mkdir -p assets/spine/operator extracted/spine/operator
mkdir assets/spine/enemy extracted/spine/enemy
mkdir assets/stages extracted/stages

cp -f Android/spritepack/sandbox*.ab assets/sandboxstages
AssetStudioModCLI assets/sandboxstages -t sprite -g none -o extracted/sandboxstages

cp -f Android/spritepack/ui_roguelike*.ab assets/rogueitems
AssetStudioModCLI assets/rogueitems -t sprite -g none -o extracted/rogueitems

cp -f apk/assets/AB/Android/ui/skin_groups.ab assets/skingroups
AssetStudioModCLI assets/skingroups -t sprite -g none -o extracted/skingroups

cp -f apk/assets/AB/Android/chararts/char*.ab assets/spine/operator
cp -f Android/chararts/char*.ab assets/spine/operator

cp -f apk/assets/AB/Android/battle/prefabs/enemies/enemy*.ab assets/spine/enemy
cp -f Android/battle/prefabs/enemies/enemy*.ab assets/spine/enemy
AssetStudioModCLI assets/spine/enemy -t tex2d,textAsset -g none -o extracted/spine/enemy

cp -f apk/assets/AB/Android/arts/ui/stage_mappreview*.ab assets/stages
cp -f Android/arts/ui/stage_mappreview*.ab assets/stages
AssetStudioModCLI assets/stages -t sprite -g none -o extracted/stages
