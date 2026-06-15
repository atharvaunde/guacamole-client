// Polyfill window for Node.js environments where the bundle expects it
if (typeof globalThis.window === 'undefined') {
  globalThis.window = globalThis;
}

// Polyfill atob for Node.js < 16
if (typeof globalThis.atob === 'undefined') {
  globalThis.atob = (b64) => Buffer.from(b64, 'base64').toString('binary');
}

require('./dist/all.js');

module.exports = globalThis.Guacamole;
