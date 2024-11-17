# Zerlpack

An [erlang term format](https://www.erlang.org/doc/apps/erts/erl_ext_dist.html) un/packer written in zig.

Supported runtimes:
 - [x] Node.js
 - [x] Electron
 - [x] Bun
 - [ ] Deno (no reexported symbols)

## Usage

```js
import { pack, unpack } from "zerlpack"; // or use require

const buffer = pack(123); // <Buffer 83 61 7b>
const value = unpack(buffer); // 123

// for compatibility with discords erlpack
const value2 = unpack(buffer, { bigintsAsStrings: true });

// optionally you can use zlib to compress the packed data
const buffer2 = pack(123, { compress: true });
```
