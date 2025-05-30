const { join } = require('path');

/**
 * @type {import("puppeteer").Configuration}
 */
module.exports = {
  cacheDirectory: join(__dirname, '.cache', 'puppeteer'), // ✅ Use writable folder
  chrome: {
    skipDownload: false, // ✅ Force Chromium to download at build
  },
};