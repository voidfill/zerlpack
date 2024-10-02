const fs = require("fs");
const headers = require("node-api-headers");

const allSymbols = new Set();
for (const version of Object.values(headers.symbols)) {
	for (const symbol of version.js_native_api_symbols) allSymbols.add(symbol);
	for (const symbol of version.node_api_symbols) allSymbols.add(symbol);
}

// these arent part of node-api but zlib and are exported by the node lib
allSymbols.add("uncompress");
allSymbols.add("compress");
allSymbols.add("compressBound");

const outSymbols = "EXPORTS\n    " + [...allSymbols].join("\n    ");

if (!fs.existsSync("def")) fs.mkdirSync("def");
fs.writeFileSync("def/node.def", outSymbols);
