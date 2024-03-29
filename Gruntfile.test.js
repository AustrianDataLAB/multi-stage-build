// Gruntfile.test.js
const processFiles = require('./processFiles');

// Mock grunt object
const grunt = {
  file: {
    read: jest.fn((path) => {
      if (path.endsWith('.html')) {
        return '<html>test content</html>';
      } else if (path.endsWith('.md')) {
        return '---\ntitle: Test\ntags: [tag1, tag2]\n---\ntest content';
      }
    }),
  },
};

describe('Gruntfile tasks', () => {
  describe('lunr-index task', () => {
    test('should process HTML files correctly', () => {
      const result = processFiles.processHTMLFile(grunt, 'blog/content/test.html', 'test.html');

      expect(result).toEqual({
        title: 'test',
        href: 'test.html',
        content: 'test content'
      });
    });

    test('should process MD files correctly', () => {
      const result = processFiles.processMDFile(grunt, 'blog/content/test.md', 'test.md');

      expect(result).toEqual({
        title: 'Test',
        tags: ['tag1', 'tag2'],
        href: 'test',
        content: 'test content'
      });
    });
  });
});