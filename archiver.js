'use strict';

// require modules
const fs = require('fs');
const archiver = require('archiver');
const pjson = require('./package.json');
const ncp = require('ncp').ncp;

function deleteFolderRecursive(path) {
    let files = [];
    if( fs.existsSync(path) ) {
        files = fs.readdirSync(path);
        files.forEach(function(file,index){
            const curPath = path + '/' + file;
            if(fs.lstatSync(curPath).isDirectory()) { // recurse
                deleteFolderRecursive(curPath);
            } else { // delete file
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
}

// create a file to stream archive data to.
const output = fs.createWriteStream(`${__dirname}/easy-frames-classic-${pjson.version}.zip`);
const archive = archiver('zip');

// listen for all archive data to be written
output.on('close', function() {
    console.log(archive.pointer() + ' total bytes');
    console.log('archiver has been finalized and the output file descriptor has closed.');

    deleteFolderRecursive('EasyFrames');
});

// good practice to catch this error explicitly
archive.on('error', function(err) {
    throw err;
});

fs.existsSync('EasyFrames') || fs.mkdirSync('EasyFrames');

ncp('Libs', './EasyFrames/Libs');
ncp('Localization', './EasyFrames/Localization');
ncp('Modules', './EasyFrames/Modules');
ncp('Textures', './EasyFrames/Textures');

ncp('Config.lua', './EasyFrames/Config.lua');
ncp('EasyFrames.lua', './EasyFrames/EasyFrames.lua');
ncp('EasyFrames.toc', './EasyFrames/EasyFrames.toc');

setTimeout(function() {
    archive.pipe(output);

    archive.glob('EasyFrames/**/*');

    archive.finalize();
}, 500);

