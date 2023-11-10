import os
import UnityPy

srcDir = 'chararts'
expDir = 'exported'

for file in os.listdir(srcDir):
    try:
        if not file.endswith('.ab'): continue

        env = UnityPy.load(os.path.join(srcDir, file))
        materials = []
        monobehaviours = []
        textassets = []
        texture2ds = []

        for obj in env.objects:
            match obj.type.name:
                case 'Material':
                    materials.append(obj)
                case 'MonoBehaviour':
                    monobehaviours.append(obj)
                case 'TextAsset':
                    textassets.append(obj)
                case 'Texture2D':
                    texture2ds.append(obj)

        for mono in monobehaviours:
            charA = mono.read()
            charATree = charA.read_typetree()
            if any(value not in charATree.keys() for value in ['_animations', '_spineSkins']): continue

            def readFromPathId(parent, list):
                return next(obj for obj in list if obj.read().path_id == parent['m_PathID']).read()
            
            # Char has both front and back spine
            if(charATree.get('_front') and charATree.get('_back')):
                fSkelA = readFromPathId(charATree['_front']['skeleton'], monobehaviours)
                fSkelDA = readFromPathId(fSkelA.read_typetree()['skeletonDataAsset'], monobehaviours)
                fSkelFile = readFromPathId(fSkelDA.read_typetree()['skeletonJSON'], textassets)
                fAtlasA = readFromPathId(fSkelDA.read_typetree()['atlasAssets'][0], monobehaviours)
                fAtlasFile = readFromPathId(fAtlasA.read_typetree()['atlasFile'], textassets)
                fMats = readFromPathId(fAtlasA.read_typetree()['materials'][0], materials)
                for tex in fMats.read_typetree()['m_SavedProperties']['m_TexEnvs']:
                    if tex[0] == '_AlphaTex':
                        fAlphaTex = readFromPathId(tex[1]['m_Texture'], texture2ds)
                    elif tex[0] == '_MainTex':
                        fMainTex = readFromPathId(tex[1]['m_Texture'], texture2ds)
            
                bSkelA = readFromPathId(charATree['_back']['skeleton'], monobehaviours)
                bSkelDA = readFromPathId(bSkelA.read_typetree()['skeletonDataAsset'], monobehaviours)
                bSkelFile = readFromPathId(bSkelDA.read_typetree()['skeletonJSON'], textassets)
                bAtlasA = readFromPathId(bSkelDA.read_typetree()['atlasAssets'][0], monobehaviours)
                bAtlasFile = readFromPathId(bAtlasA.read_typetree()['atlasFile'], textassets)
                bMats = readFromPathId(bAtlasA.read_typetree()['materials'][0], materials)
                for tex in bMats.read_typetree()['m_SavedProperties']['m_TexEnvs']:
                    if tex[0] == '_AlphaTex':
                        bAlphaTex = readFromPathId(tex[1]['m_Texture'], texture2ds)
                    elif tex[0] == '_MainTex':
                        bMainTex = readFromPathId(tex[1]['m_Texture'], texture2ds)

                charName = file.split('.ab')[0]
                fDir = f'{expDir}/{charName}/front'
                bDir = f'{expDir}/{charName}/back'
                if not os.path.exists(expDir):
                    os.mkdir(expDir)
                if not os.path.exists(f'{expDir}/{charName}'):
                    os.mkdir(f'{expDir}/{charName}')
                if not os.path.exists(fDir):
                    os.mkdir(fDir)
                if not os.path.exists(bDir):
                    os.mkdir(bDir)

                open(f'{fDir}/{fSkelFile.name}', 'wb').write(fSkelFile.script)
                open(f'{fDir}/{fAtlasFile.name}', 'wb').write(fAtlasFile.script)
                fAlphaTex.image.save(f'{fDir}/{fAlphaTex.name}.png')
                fMainTex.image.save(f'{fDir}/{fMainTex.name}.png')

                open(f'{bDir}/{bSkelFile.name}', 'wb').write(bSkelFile.script)
                open(f'{bDir}/{bAtlasFile.name}', 'wb').write(bAtlasFile.script)
                bAlphaTex.image.save(f'{bDir}/{bAlphaTex.name}.png')
                bMainTex.image.save(f'{bDir}/{bMainTex.name}.png')
            # Char has only front spine
            else:
                fSkelA = readFromPathId(charATree['_skeleton'], monobehaviours)
                fSkelDA = readFromPathId(fSkelA.read_typetree()['skeletonDataAsset'], monobehaviours)
                fSkelFile = readFromPathId(fSkelDA.read_typetree()['skeletonJSON'], textassets)
                fAtlasA = readFromPathId(fSkelDA.read_typetree()['atlasAssets'][0], monobehaviours)
                fAtlasFile = readFromPathId(fAtlasA.read_typetree()['atlasFile'], textassets)
                fMats = readFromPathId(fAtlasA.read_typetree()['materials'][0], materials)
                for tex in fMats.read_typetree()['m_SavedProperties']['m_TexEnvs']:
                    if tex[0] == '_AlphaTex':
                        fAlphaTex = readFromPathId(tex[1]['m_Texture'], texture2ds)
                    elif tex[0] == '_MainTex':
                        fMainTex = readFromPathId(tex[1]['m_Texture'], texture2ds)

                charName = file.split('.ab')[0]
                fDir = f'{expDir}/{charName}/front'
                if not os.path.exists(expDir):
                    os.mkdir(expDir)
                if not os.path.exists(f'{expDir}/{charName}'):
                    os.mkdir(f'{expDir}/{charName}')
                if not os.path.exists(fDir):
                    os.mkdir(fDir)

                open(f'{fDir}/{fSkelFile.name}', 'wb').write(fSkelFile.script)
                open(f'{fDir}/{fAtlasFile.name}', 'wb').write(fAtlasFile.script)
                fAlphaTex.image.save(f'{fDir}/{fAlphaTex.name}.png')
                fMainTex.image.save(f'{fDir}/{fMainTex.name}.png')
    except:
        print(f'Error: {file}')
        continue


# Spine assets hierarchy tree (normal)
# 
#                                               CharacterAnimator
#                                                |              |
#                                                |              |
#                           SkeletonAnimation (front)         SkeletonAnimation (back)
#                                       |                               |
#                                       |                               |
#                           SkeletonDataAsset (front)         SkeletonDataAsset (back)
#                           |               |                       |               |
#                           |               |                       |               |
#                   AtlasAssets       SkeletonFile              AtlasAssets       SkeletonFile
#                   |       |                                   |       |
#                   |       |                                   |       |
#               AtlasFile   Materials                       AtlasFile   Materials
#                           |       |                                   |       |
#                           |       |                                   |       |
#                       AlphaTex  MainTex                           AlphaTex    MainTex


# Spine assets hierarchy tree (skadi2, sora, aglina, heidi, ulika)
# 
#                                               SingleSpineAnimator
#                                                       |
#                                                       |
#                                               SkeletonAnimation
#                                                       |
#                                                       |
#                                               SkeletonDataAsset
#                                                 |           |
#                                                 |           |
#                                         AtlasAssets       SkeletonFile
#                                         |       |
#                                         |       |
#                                     AtlasFile   Materials
#                                                 |       |
#                                                 |       |
#                                             AlphaTex  MainTex