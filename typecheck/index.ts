import { BaseIO, CCStageIO, DefinitionIO, EnemyIO, GameEventIO, ItemIO, ModuleIO, OperatorIO, ParadoxIO, GridRangeIO, RogueThemeIO, SandboxActIO, SkillIO, SkinIO, StageIO, StageDataIO } from "hella-types";
import { MongoClient } from "mongodb";
import 'dotenv/config';
import { PathReporter } from 'io-ts/PathReporter'
import fs from 'fs';

const logPath = 'log.txt';
fs.writeFileSync(logPath, '');
const log = (msg: string) => fs.appendFileSync(logPath, msg + '\n');

async function main() {
    const connectionString = process.env.ATLAS_URI || "";
    const client = new MongoClient(connectionString);
    const db = (await client.connect()).db("arknights");

    console.log('base');
    const baseCollection = db.collection("baseskills");
    const baseResults = await baseCollection.find({}).toArray();
    for (const base of baseResults) {
        const result = BaseIO.decode(base.value);
        if (result._tag === "Left") {
            log('Base type conformity error: ' + base.keys + '\n');
            log(PathReporter.report(result).join('\n'));
        }
    }
    console.log('ccstages');
    const ccCollection = db.collection("ccstages");
    const ccResults = await ccCollection.find({}).toArray();
    for (const cc of ccResults) {
        const result = CCStageIO.decode(cc.value);
        if (result._tag === "Left") {
            log('CC stage type conformity error: ' + cc.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('definitions');
    const definitionCollection = db.collection("definitions");
    const definitionResults = await definitionCollection.find({}).toArray();
    for (const definition of definitionResults) {
        const result = DefinitionIO.decode(definition.value);
        if (result._tag === "Left") {
            log('Definition type conformity error: ' + definition.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('enemies');
    const enemyCollection = db.collection("enemies");
    const enemyResults = await enemyCollection.find({}).toArray();
    for (const enemy of enemyResults) {
        const result = EnemyIO.decode(enemy.value);
        if (result._tag === "Left") {
            log('Enemy type conformity error: ' + enemy.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('events');
    const gameEventCollection = db.collection("events");
    const gameEventResults = await gameEventCollection.find({}).toArray();
    for (const gameEvent of gameEventResults) {
        const result = GameEventIO.decode(gameEvent.value);
        if (result._tag === "Left") {
            log('Game event type conformity error: ' + gameEvent.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('items');
    const itemCollection = db.collection("items");
    const itemResults = await itemCollection.find({}).toArray();
    for (const item of itemResults) {
        const result = ItemIO.decode(item.value);
        if (result._tag === "Left") {
            log('Item type conformity error: ' + item.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('modules');
    const moduleCollection = db.collection("modules");
    const moduleResults = await moduleCollection.find({}).toArray();
    for (const module of moduleResults) {
        const result = ModuleIO.decode(module.value);
        if (result._tag === "Left") {
            log('Module type conformity error: ' + module.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('operators');
    const operatorCollection = db.collection("operators");
    const operatorResults = await operatorCollection.find({}).toArray();
    for (const operator of operatorResults) {
        const result = OperatorIO.decode(operator.value);
        if (result._tag === "Left") {
            log('Operator type conformity error: ' + operator.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('paradoxes');
    const paradoxCollection = db.collection("paradoxes");
    const paradoxResults = await paradoxCollection.find({}).toArray();
    for (const paradox of paradoxResults) {
        const result = ParadoxIO.decode(paradox.value);
        if (result._tag === "Left") {
            log('Paradox type conformity error: ' + paradox.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('ranges');
    const rangeCollection = db.collection("ranges");
    const rangeResults = await rangeCollection.find({}).toArray();
    for (const range of rangeResults) {
        const result = GridRangeIO.decode(range.value);
        if (result._tag === "Left") {
            log('Range type conformity error: ' + range.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('rogue themes');
    const rogueThemeCollection = db.collection("roguethemes");
    const rogueThemeResults = await rogueThemeCollection.find({}).toArray();
    for (const rogueTheme of rogueThemeResults) {
        const result = RogueThemeIO.decode(rogueTheme.value);
        if (result._tag === "Left") {
            log('Rogue theme type conformity error: ' + rogueTheme.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('sandboxes');
    const sandboxActCollection = db.collection("sandboxes");
    const sandboxActResults = await sandboxActCollection.find({}).toArray();
    for (const sandboxAct of sandboxActResults) {
        const result = SandboxActIO.decode(sandboxAct.value);
        if (result._tag === "Left") {
            log('Sandbox act type conformity error: ' + sandboxAct.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('skills');
    const skillCollection = db.collection("skills");
    const skillResults = await skillCollection.find({}).toArray();
    for (const skill of skillResults) {
        const result = SkillIO.decode(skill.value);
        if (result._tag === "Left") {
            log('Skill type conformity error: ' + skill.keys + '\n');
            log(PathReporter.report(result).join('\n'));
            break;
        }
    }
    console.log('skins');
    const skinCollection = db.collection("skins");
    const skinResults = await skinCollection.find({}).toArray();
    for (const skins of skinResults) {
        for (const skin of skins.value) {
            const result = SkinIO.decode(skin);
            if (result._tag === "Left") {
                log('Skin type conformity error: ' + skins.keys + '\n');
                log(PathReporter.report(result).join('\n'));
                break;
            }
        }
    }
    console.log('stages');
    const stageCollection = db.collection("stages");
    const stageResults = await stageCollection.find({}).toArray();
    for (const stages of stageResults) {
        let stop = false;
        for (const stage of stages.value) {
            const result = StageIO.decode(stage);
            if (result._tag === "Left") {
                log('Stage type conformity error: ' + stages.keys + '\n');
                log(PathReporter.report(result).join('\n'));
                stop = true;
                break;
            }
        }
        if (stop) break;
    }
    console.log('tough stages');
    const toughCollection = db.collection("toughstages");
    const toughResults = await toughCollection.find({}).toArray();
    for (const stages of toughResults) {
        let stop = false;
        for (const stage of stages.value) {
            const result = StageIO.decode(stage);
            if (result._tag === "Left") {
                log('Tough stage type conformity error: ' + stages.keys + '\n');
                log(PathReporter.report(result).join('\n'));
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