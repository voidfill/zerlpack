import { expect, test } from "vitest";

const zerl = require("../index.js");

test("Fails to pack functions", () => {
	expect(() => zerl.pack(() => { })).toThrowError("Functions are not supported");
});

test("Fails to pack Symbols", () => {
	expect(() => zerl.pack(Symbol("test"))).toThrowError("Symbols are not supported");
});

test("Packs undefined", () => {
	expect(zerl.pack(undefined)).toEqual(Buffer.from([131, 119, 3, 110, 105, 108]));
	expect(zerl.pack()).toEqual(Buffer.from([131, 119, 3, 110, 105, 108]));
});

test("Packs null", () => {
	expect(zerl.pack(null)).toEqual(Buffer.from([131, 119, 3, 110, 105, 108]));
});

test("Packs true", () => {
	expect(zerl.pack(true)).toEqual(Buffer.from([131, 119, 4, 116, 114, 117, 101]));
});

test("Packs false", () => {
	expect(zerl.pack(false)).toEqual(Buffer.from([131, 119, 5, 102, 97, 108, 115, 101]));
});

test("Packs strings", () => {
	expect(zerl.pack("")).toEqual(Buffer.from([131, 109, 0, 0, 0, 0]));
	expect(zerl.pack("abc")).toEqual(Buffer.from([131, 109, 0, 0, 0, 3, 97, 98, 99]));
});

test("Packs arrays", () => {
	expect(zerl.pack([])).toEqual(Buffer.from([131, 108, 0, 0, 0, 0, 106]));
	expect(zerl.pack(["", ""])).toEqual(Buffer.from([131, 108, 0, 0, 0, 2, 109, 0, 0, 0, 0, 109, 0, 0, 0, 0, 106]));
});

test("Packs objects", () => {
	expect(zerl.pack({})).toEqual(Buffer.from([131, 116, 0, 0, 0, 0]));
	expect(zerl.pack({ "": "" })).toEqual(Buffer.from([131, 116, 0, 0, 0, 1, 109, 0, 0, 0, 0, 109, 0, 0, 0, 0]));
});

test("Packs big integers", () => {
	expect(zerl.pack(0n)).toEqual(Buffer.from([131, 110, 0, 0]));
	expect(zerl.pack(1n)).toEqual(Buffer.from([131, 110, 1, 0, 1]));
	expect(zerl.pack(-1n)).toEqual(Buffer.from([131, 110, 1, 1, 1]));
	expect(zerl.pack(255n)).toEqual(Buffer.from([131, 110, 1, 0, 255]));
	expect(zerl.pack(256n)).toEqual(Buffer.from([131, 110, 2, 0, 0, 1]));
	expect(zerl.pack(18446744073709551616n)).toEqual(Buffer.from([131, 110, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]));
});

test("Packs floats", () => {
	expect(zerl.pack(2.5)).toEqual(Buffer.from([131, 70, 64, 4, 0, 0, 0, 0, 0, 0]));
	expect(zerl.pack(51512123841234.31423412341435123412341342)).toEqual(Buffer.from([131, 70, 66, 199, 108, 204, 235, 237, 105, 40]));
});

test("Packs small integers", () => {
	expect(zerl.pack(0)).toEqual(Buffer.from([131, 97, 0]));
	expect(zerl.pack(1)).toEqual(Buffer.from([131, 97, 1]));
	expect(zerl.pack(255)).toEqual(Buffer.from([131, 97, 255]));
});

test("Packs int32s", () => {
	expect(zerl.pack(256)).toEqual(Buffer.from([131, 98, 0, 0, 1, 0]));
	expect(zerl.pack(-1)).toEqual(Buffer.from([131, 98, 255, 255, 255, 255]));
	expect(zerl.pack(2147483647)).toEqual(Buffer.from([131, 98, 127, 255, 255, 255]));
	expect(zerl.pack(-2147483648)).toEqual(Buffer.from([131, 98, 128, 0, 0, 0]));
});

test("Packs uint32s as bigints", () => {
	expect(zerl.pack(2147483648n)).toEqual(Buffer.from([131, 110, 4, 0, 0, 0, 0, 128]));
	expect(zerl.pack(4294967295n)).toEqual(Buffer.from([131, 110, 4, 0, 255, 255, 255, 255]));
});
