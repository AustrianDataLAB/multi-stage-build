// processFiles.js
var yaml = require('yamljs');
var S = require('string');
var CONTENT_PATH_PREFIX = "blog/content/"

function processHTMLFile(grunt, abspath, filename) {
    var content = grunt.file.read(abspath);
    var pageName = S(filename).chompRight(".html").s;
    var href = S(abspath)
        .chompLeft(CONTENT_PATH_PREFIX).s;
    return {
        title: pageName,
        href: href,
        content: S(content).trim().stripTags().stripPunctuation().s
    };
};

function processMDFile(grunt, abspath, filename) {
    var content = grunt.file.read(abspath);
    var pageIndex;
    // First separate the Front Matter from the content and parse it
    content = content.split("---");
    var frontMatter;
    try {
        frontMatter = yaml.parse(content[1].trim());
    } catch (e) {
        console.failed(e.message);
    }

    var href = S(abspath).chompLeft(CONTENT_PATH_PREFIX).chompRight(".md").s;
    // href for index.md files stops at the folder name
    if (filename === "index.md") {
        href = S(abspath).chompLeft(CONTENT_PATH_PREFIX).chompRight(filename).s;
    }

    // Build Lunr index for this page
    pageIndex = {
        title: frontMatter.title,
        tags: frontMatter.tags,
        href: href,
        content: S(content[2]).trim().stripTags().stripPunctuation().s
    };

    return pageIndex;
};

module.exports = {
    processHTMLFile: processHTMLFile,
    processMDFile: processMDFile
};