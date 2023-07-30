const path = require('path');
const fs = require('fs');

const folder = path.join(__dirname, 'TextAsset');

fs.readdirSync(folder).forEach(file => {
    if (path.extname(file) !== '.atlas' && path.extname(file) !== '.skel') return;

    try {
        let name = path.parse(file).name;
        const contents = fs.readFileSync(path.join(folder, file));
        const front = (contents.toString().match(/F_/g) || []).length;
        const back = (contents.toString().match(/B_/g) || []).length;

        try {
            if (front > back)
                fs.renameSync(path.join(folder, file), path.join(__dirname, 'spine', name, 'front', file));
            else if (front < back)
                fs.renameSync(path.join(folder, file), path.join(__dirname, 'spine', name, 'back', file));
            else
                console.log(`weird: ` + file);
        } catch (e) {
            name = name.substring(0, name.length - 3);
            if (front > back)
                fs.renameSync(path.join(folder, file), path.join(__dirname, 'spine', name, 'front', file));
            else if (front < back)
                fs.renameSync(path.join(folder, file), path.join(__dirname, 'spine', name, 'back', file));
            else
                console.log(`weird: ` + file);
        }
    }
    catch (e) {
        console.log(file);
        console.error(e);
        process.exit();
    }
});