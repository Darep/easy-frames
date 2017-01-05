'use strict';

// require modules
var fs = require('fs');
var archiver = require('archiver');

// create a file to stream archive data to.
var output = fs.createWriteStream(__dirname + '/easy-frames.zip');
var archive = archiver('zip',  {
    store: true // Sets the compression method to STORE.
});

// listen for all archive data to be written
output.on('close', function() {
    console.log(archive.pointer() + ' total bytes');
    console.log('archiver has been finalized and the output file descriptor has closed.');
});

// good practice to catch this error explicitly
archive.on('error', function(err) {
    throw err;
});

archive.pipe(output);

archive.glob("Libs/**/*");
archive.glob("Localization/**/*");
archive.glob("Modules/**/*");
archive.glob("Textures/**/*");
archive.glob("Config.lua");
archive.glob("EasyFrames.lua");
archive.glob("EasyFrames.toc");

// finalize the archive (ie we are done appending files but streams have to finish yet)
archive.finalize();
