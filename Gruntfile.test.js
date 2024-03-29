// Gruntfile.test.js
const grunt = require('grunt');
const tasks = require('./Gruntfile');
const S = require('string');
const yaml = require('yamljs');

// Mock the grunt.file.read function
grunt.file.read = jest.fn();

// Mock the grunt.file.write function
grunt.file.write = jest.fn();

// Mock the grunt.log.ok function
grunt.log.ok = jest.fn();

// Mock the grunt.file.recurse function
grunt.file.recurse = jest.fn();

// Initialize the tasks
tasks(grunt);

describe('Gruntfile tasks', () => {
  describe('lunr-index task', () => {
    it('should process HTML files correctly', () => {
      const content = '<h1>Hello, world!</h1>';
      grunt.file.read.mockReturnValue(content);

      const processHTMLFile = grunt.task._tasks['lunr-index'].info.processHTMLFile;
      const result = processHTMLFile('blog/content/test.html', 'test.html');

      expect(result).toEqual({
        title: 'test',
        href: 'test.html',
        content: 'Hello world'
      });
    });

    it('should process MD files correctly', () => {
      const content = '---\ntitle: Test\ntags: [tag1, tag2]\n---\n# Hello, world!';
      grunt.file.read.mockReturnValue(content);

      const processMDFile = grunt.task._tasks['lunr-index'].info.processMDFile;
      const result = processMDFile('blog/content/test.md', 'test.md');

      expect(result).toEqual({
        title: 'Test',
        tags: ['tag1', 'tag2'],
        href: 'test',
        content: 'Hello world'
      });
    });
  });
});