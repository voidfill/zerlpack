# Zerlpack

An [erlang term format](https://www.erlang.org/doc/apps/erts/erl_ext_dist.html) un/packer written in zig.

## Usage

```js
import { pack, unpack } from "zerlpack"; // or use require

const buffer = pack(123);
const value = unpack(buffer);

// optionally you can use zlib to compress the packed data
const buffer2 = pack(123, true);
```

## Caveats

Currently every number encoded as big integer will be converted to a js bigint. I may add an option to turn them into strings in the future.

This is a native node module built against [napi](https://nodejs.org/api/n-api.html) so dont expect it to work on deno, bun or very old node versions.
