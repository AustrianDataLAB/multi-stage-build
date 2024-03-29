// Gruntfile.js
var yaml = require('yamljs');
var S = require('string');
var processFiles = require('./processFiles');

var CONTENT_PATH_PREFIX = "blog/content/"

module.exports = function(grunt) {

    grunt.registerTask("lunr-index", function() {

        grunt.log.writeln("Build pages index");

        var indexPages = function() {
            var pagesIndex = [];
            grunt.file.recurse(CONTENT_PATH_PREFIX, function(abspath, rootdir, subdir, filename) {
                console.log("Using: ", abspath);
                grunt.verbose.writeln("Parse file:",abspath);
                pagesIndex.push(processFile(grunt, abspath, filename));
            });

            return pagesIndex;
        };

        var processFile = function(grunt, abspath, filename) {
            var pageIndex;

            if (S(filename).endsWith(".html")) {
                pageIndex = processFiles.processHTMLFile(grunt, abspath, filename);
            } else {
                pageIndex = processFiles.processMDFile(grunt, abspath, filename);
            }

            return pageIndex;
        };

        grunt.file.write("blog/static/js/lunr/PagesIndex.json", JSON.stringify(indexPages()));
        grunt.log.ok("Index built");
    });
};