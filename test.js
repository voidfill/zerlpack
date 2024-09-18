const addon = require('./zig-out/zerlpack.node');

const buf = new Uint8Array([131, 109, 0, 0, 0, 2, 104, 105 ]);

console.log(addon.decode(buf));
