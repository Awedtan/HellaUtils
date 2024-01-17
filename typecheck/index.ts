import { BaseZod, CCStageZod, DefinitionZod, EnemyZod, GameEventZod, GridRangeZod, ItemZod, ModuleZod, OperatorZod, ParadoxZod, RogueThemeZod, SandboxActZod, SkillZod, SkinZod, StageZod } from "hella-types";
import { MongoClient } from "mongodb";
import 'dotenv/config';
import * as fs from 'fs';

const logPath = 'log.txt';
fs.writeFileSync(logPath, '');
const log = (msg: string) => fs.appendFileSync(logPath, msg + '\n');

async function main() {
    const connectionString = process.env.ATLAS_URI || "";
    const client = new MongoClient(connectionString);
    const db = (await client.connect()).db("arknights");

    console.log('base');
    const baseCollection = db.collection("baseskills");
    const baseResults = await baseCollection.find().toArray();
    for (const base of baseResults) {
        try {
            BaseZod.parse(base.value);
        } catch (e: any) {
            log('Base type conformity error: ' + base.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('ccstages');
    const ccCollection = db.collection("ccstages");
    const ccResults = await ccCollection.find().toArray();
    for (const cc of ccResults) {
        try {
            CCStageZod.parse(cc.value);
        } catch (e: any) {
            log('CC type conformity error: ' + cc.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('definitions');
    const definitionCollection = db.collection("definitions");
    const definitionResults = await definitionCollection.find().toArray();
    for (const definition of definitionResults) {
        try {
            DefinitionZod.parse(definition.value);
        } catch (e: any) {
            log('Definition type conformity error: ' + definition.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('enemies');
    const enemyCollection = db.collection("enemies");
    const enemyResults = await enemyCollection.find().toArray();
    for (const enemy of enemyResults) {
        try {
            EnemyZod.parse(enemy.value);
        } catch (e: any) {
            log('Enemy type conformity error: ' + enemy.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('events');
    const gameEventCollection = db.collection("events");
    const gameEventResults = await gameEventCollection.find().toArray();
    for (const gameEvent of gameEventResults) {
        try {
            GameEventZod.parse(gameEvent.value);
        } catch (e: any) {
            log('Game event type conformity error: ' + gameEvent.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('items');
    const itemCollection = db.collection("items");
    const itemResults = await itemCollection.find().toArray();
    for (const item of itemResults) {
        try {
            ItemZod.parse(item.value);
        } catch (e: any) {
            log('Item type conformity error: ' + item.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('modules');
    const moduleCollection = db.collection("modules");
    const moduleResults = await moduleCollection.find().toArray();
    for (const module of moduleResults) {
        try {
            ModuleZod.parse(module.value);
        } catch (e: any) {
            log('Module type conformity error: ' + module.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('operators');
    const operatorCollection = db.collection("operators");
    const operatorResults = await operatorCollection.find().toArray();
    for (const operator of operatorResults) {
        try {
            OperatorZod.parse(operator.value);
        } catch (e: any) {
            log('Operator type conformity error: ' + operator.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('paradoxes');
    const paradoxCollection = db.collection("paradoxes");
    const paradoxResults = await paradoxCollection.find().toArray();
    for (const paradox of paradoxResults) {
        try {
            ParadoxZod.parse(paradox.value);
        } catch (e: any) {
            log('Paradox type conformity error: ' + paradox.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('ranges');
    const rangeCollection = db.collection("ranges");
    const rangeResults = await rangeCollection.find().toArray();
    for (const range of rangeResults) {
        try {
            GridRangeZod.parse(range.value);
        } catch (e: any) {
            log('Range type conformity error: ' + range.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('rogue themes');
    const rogueThemeCollection = db.collection("roguethemes");
    const rogueThemeResults = await rogueThemeCollection.find().toArray();
    for (const rogueTheme of rogueThemeResults) {
        try {
            RogueThemeZod.parse(rogueTheme.value);
        } catch (e: any) {
            log('Rogue theme type conformity error: ' + rogueTheme.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('sandboxes');
    const sandboxActCollection = db.collection("sandboxes");
    const sandboxActResults = await sandboxActCollection.find().toArray();
    for (const sandboxAct of sandboxActResults) {
        try {
            SandboxActZod.parse(sandboxAct.value);
        } catch (e: any) {
            log('Sandbox type conformity error: ' + sandboxAct.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('skills');
    const skillCollection = db.collection("skills");
    const skillResults = await skillCollection.find().toArray();
    for (const skill of skillResults) {
        try {
            SkillZod.parse(skill.value);
        } catch (e: any) {
            log('Skill type conformity error: ' + skill.keys + '\n');
            log(e);
            break;
        }
    }
    console.log('skins');
    const skinCollection = db.collection("skins");
    const skinResults = await skinCollection.find().toArray();
    for (const skins of skinResults) {
        let stop = false;
        for (const skin of skins.value) {
            try {
                SkinZod.parse(skin);
            } catch (e: any) {
                log('Skin type conformity error: ' + skins.keys + '\n');
                log(e);
                stop = true;
                break;
            }
        }
        if (stop) break;
    }
    console.log('stages');
    const stageCollection = db.collection("stages");
    const stageResults = await stageCollection.find().toArray();
    for (const stages of stageResults) {
        let stop = false;
        for (const stage of stages.value) {
            try {
                StageZod.parse(stage);
            } catch (e: any) {
                log('Stage type conformity error: ' + stages.keys + '\n');
                log(e);
                stop = true;
                break;
            }
        }
        if (stop) break;
    }
    console.log('tough stages');
    const toughCollection = db.collection("toughstages");
    const toughResults = await toughCollection.find().toArray();
    for (const stages of toughResults) {
        let stop = false;
        for (const stage of stages.value) {
            try {
                StageZod.parse(stage);
            } catch (e: any) {
                log('Tough stage type conformity error: ' + stages.keys + '\n');
                log(e);
                stop = true;
                break;
            }
        }
        if (stop) break;
    }
    log('\ndone');
    process.exit();
}

main();