import { expect, test } from "vitest";

const zerl = require("../index.js");

function unp(array: number[]) {
	return zerl.unpack(new Uint8Array(array));
}

function unpBin(binary: string) {
	return zerl.unpack(Buffer.from(binary, "binary"));
}

function stringToArray(str: string) {
	return new Uint8Array(str.split("").map((c) => c.charCodeAt(0)));
}

test("Fails to construct a Decoder", () => {
	expect(() => unp([])).toThrowError("Buffer is empty");
	expect(() => unp([0])).toThrowError("WrongFormatVersion");
	expect(() => unp([131])).toThrowError("BufferSizeMismatch");
});

test("Fails to decode a buffer with items leftover", () => {
	expect(() => unp([131, 97, 0, 69])).toThrowError("BufferSizeMismatch: Items leftover.");
});

test("Fails to decode an invalid tag", () => {
	expect(() => unp([131, 32, 0, 0, 0, 0])).toThrowError("Unknown tag");
});

test("Fails to decode unsupported tags", () => {
	expect(() => unp([131, 68])).toThrowError("Distribution header is not supported");
	expect(() => unp([131, 69])).toThrowError("Distribution header is not supported");
	expect(() => unp([131, 77])).toThrowError("Bit binary is not supported");
	expect(() => unp([131, 82])).toThrowError("Atom cache ref is not supported");
})

test("Unpacks an empty array", () => {
	expect(unp([131, 106])).toEqual([]);
});

test("Unpacks an Integer", () => {
	expect(unp([131, 98, 0, 0, 0, 0])).toEqual(0);
	expect(unp([131, 98, 0, 0, 0, 1])).toEqual(1);
	expect(unp([131, 98, 255, 255, 255, 255])).toEqual(-1);
	expect(unp([131, 98, 128, 0, 0, 0])).toEqual(-2_147_483_648);
	expect(unp([131, 98, 127, 255, 255, 255])).toEqual(2_147_483_647);

	expect(() => unp([131, 98, 128, 0, 0])).toThrowError("BufferSizeMismatch");
});

test("Unpacks a Small Integer", () => {
	expect(unp([131, 97, 0])).toEqual(0);
	expect(unp([131, 97, 1])).toEqual(1);
	expect(unp([131, 97, 255])).toEqual(255);

	expect(() => unp([131, 97])).toThrowError("BufferSizeMismatch");
});

test("Unpacks atom", () => {
	expect(unp([131, 100, 0, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(unp([131, 100, 0, 4, ...stringToArray("true")])).toEqual(true);
	expect(unp([131, 100, 0, 5, ...stringToArray("false")])).toEqual(false);
	expect(unp([131, 100, 0, 3, ...stringToArray("nil")])).toEqual(null);
	expect(unp([131, 100, 0, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => unp([131, 100, 0, 1])).toThrowError("BufferSizeMismatch");

});

test("Unpacks small atom", () => {
	expect(unp([131, 115, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(unp([131, 115, 4, ...stringToArray("true")])).toEqual(true);
	expect(unp([131, 115, 5, ...stringToArray("false")])).toEqual(false);
	expect(unp([131, 115, 3, ...stringToArray("nil")])).toEqual(null);
	expect(unp([131, 115, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => unp([131, 115, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks Utf8 atom", () => {
	expect(unp([131, 118, 0, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(unp([131, 118, 0, 4, ...stringToArray("true")])).toEqual(true);
	expect(unp([131, 118, 0, 5, ...stringToArray("false")])).toEqual(false);
	expect(unp([131, 118, 0, 3, ...stringToArray("nil")])).toEqual(null);
	expect(unp([131, 118, 0, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => unp([131, 118, 0, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks small Utf8 atom", () => {
	expect(unp([131, 119, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(unp([131, 119, 4, ...stringToArray("true")])).toEqual(true);
	expect(unp([131, 119, 5, ...stringToArray("false")])).toEqual(false);
	expect(unp([131, 119, 3, ...stringToArray("nil")])).toEqual(null);
	expect(unp([131, 119, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => unp([131, 119, 1])).toThrowError("BufferSizeMismatch");

	// TODO: test utf8 somehow? no idea.
});

test("Unpacks binary as string", () => {
	expect(unp([131, 109, 0, 0, 0, 6, ...stringToArray("binary")])).toEqual("binary");
	expect(unp([131, 109, 0, 0, 0, 4, ...stringToArray("true")])).toEqual("true");
	expect(() => unp([131, 109, 0, 0, 0, 1])).toThrowError("BufferSizeMismatch");
});


test("Unpacks small Tuple", () => {
	expect(unp([131, 104, 1, 106])).toEqual([[]]);
	expect(unp([131, 104, 2, 106, 106])).toEqual([[], []]);
	expect(() => unp([131, 104, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks large Tuple", () => {
	expect(unp([131, 105, 0, 0, 0, 1, 106])).toEqual([[]]);
	expect(unp([131, 105, 0, 0, 0, 2, 106, 106])).toEqual([[], []]);
	expect(() => unp([131, 105, 0, 0, 0, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks old Float", () => {
	expect(unpBin("\x83c2.50000000000000000000e+00\x00\x00\x00\x00\x00")).toEqual(2.5);
	expect(unpBin("\x83c200000.50000000000000000000e+00")).toEqual(200000.5);
	expect(unpBin("\x83c5.15121238412343125000e+13\x00\x00\x00\x00\x00")).toEqual(51512123841234.31423412341435123412341342);
	expect(() => unp([131, 99, 0])).toThrowError("BufferSizeMismatch");
});

test("Unpacks new Float", () => {
	expect(unpBin("\x83F\x40\x04\x00\x00\x00\x00\x00\x00")).toEqual(2.5);
	expect(unpBin("\x83F\x42\xC7\x6C\xCC\xEB\xED\x69\x28")).toEqual(51512123841234.31423412341435123412341342)
	expect(() => unp([131, 70, 0])).toThrowError("BufferSizeMismatch");
});

test("Unpacks small Big", () => {
	expect(unp([131, 110, 1, 0, 0])).toEqual(0n);
	expect(unp([131, 110, 1, 0, 1])).toEqual(1n);
	expect(unp([131, 110, 1, 1, 1])).toEqual(-1n);

	expect(unp([131, 110, 0, 0])).toEqual(0n);
	expect(unp([131, 110, 0, 1])).toEqual(-0n);

	expect(unp([131, 110, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0])).toEqual(1n);
	expect(unp([131, 110, 9, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0])).toEqual(257n);
	expect(unp([131, 110, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1])).toEqual(18446744073709551617n);

	expect(() => unp([131, 110])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 110, 0, 0, 1])).toThrowError("BufferSizeMismatch");
})

test("Unpacks large Big", () => {
	expect(unp([131, 111, 0, 0, 0, 1, 0, 0])).toEqual(0n);
	expect(unp([131, 111, 0, 0, 0, 1, 0, 1])).toEqual(1n);
	expect(unp([131, 111, 0, 0, 0, 1, 1, 1])).toEqual(-1n);

	expect(unp([131, 111, 0, 0, 0, 0, 0])).toEqual(0n);
	expect(unp([131, 111, 0, 0, 0, 0, 1])).toEqual(-0n);

	expect(unp([131, 111, 0, 0, 0, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0])).toEqual(1n);
	expect(unp([131, 111, 0, 0, 0, 9, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0])).toEqual(257n);
	expect(unp([131, 111, 0, 0, 0, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1])).toEqual(18446744073709551617n);

	expect(() => unp([131, 111, 0, 0, 0])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 111, 0, 0, 0, 0, 0, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks list", () => {
	expect(unp([131, 108, 0, 0, 0, 0, 106])).toEqual([]);
	expect(unp([131, 108, 0, 0, 0, 1, 106, 106])).toEqual([[]]);
	expect(unp([131, 108, 0, 0, 0, 2, 106, 106, 106])).toEqual([[], []]);

	expect(() => unp([131, 108, 0, 0, 0, 1, 106, 0])).toThrowError("Invalid tail");
	expect(() => unp([131, 108, 0, 0, 0, 1, 106])).toThrowError("BufferSizeMismatch");
});

test("Unpacks map", () => {
	expect(unp([131, 116, 0, 0, 0, 0])).toEqual({});
	expect(unp([131, 116, 0, 0, 0, 1, 97, 0, 106])).toEqual({ 0: [] });
	expect(unp([131, 116, 0, 0, 0, 2, 97, 0, 106, 97, 1, 106])).toEqual({ 0: [], 1: [] });
	expect(unp([131, 116, 0, 0, 0, 1, 115, 1, 97, 106])).toEqual({ "a": [] });
	expect(unp([131, 116, 0, 0, 0, 2, 115, 1, 97, 106, 115, 1, 98, 106])).toEqual({ "a": [], "b": [] });

	expect(() => unp([131, 116, 0, 0, 0])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 116, 0, 0, 0, 1])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 116, 0, 0, 0, 1, 97, 0])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 116, 0, 0, 0, 1, 97, 0, 97])).toThrowError("BufferSizeMismatch");
});

test("Unpacks string as array of integers", () => {
	expect(unp([131, 107, 0, 0])).toEqual([]);
	expect(unp([131, 107, 0, 1, 97])).toEqual([97]);
	expect(unp([131, 107, 0, 2, 97, 98])).toEqual([97, 98]);

	expect(() => unp([131, 107, 0])).toThrowError("BufferSizeMismatch");
	expect(() => unp([131, 107, 0, 1])).toThrowError("BufferSizeMismatch");
});

test("Unpacks compressed data", () => {
	const expected = [2, Array.from("it's getting hot in here.").map(x => x.charCodeAt(0))]

	expect(unpBin("\x83l\x00\x00\x00\x02a\x02k\x00\x19it\'s getting hot in here.j")).toEqual(expected);
	expect(unpBin("\x83P\x00\x00\x00\x24\x78\x9C\xCB\x61\x60\x60\x60\x4A\x64\xCA\x66\x90\xCC\x2C\x51\x2F\x56\x48\x4F\x2D\x29\xC9\xCC\x4B\x57\xC8\xC8\x2F\x51\xC8\xCC\x53\xC8\x48\x2D\x4A\xD5\xCB\x02\x00\xA8\xA8\x0A\x9D")).toEqual(expected);
	expect(() => unp([131, 80, 0, 0, 0, 0])).toThrowError("Failed to uncompress");
});

test("Unpacks nested compressed data", () => {
	const expected = [[2, Array.from("it's getting hot in here.").map(x => x.charCodeAt(0))], 3];

	expect(unpBin("\x83l\x00\x00\x00\x02l\x00\x00\x00\x02a\x02k\x00\x19it\'s getting hot in here.ja\x03j")).toEqual(expected);
	expect(unpBin("\x83P\x00\x00\x00\x2C\x78\x9C\xCB\x61\x60\x60\x60\xCA\x01\x11\x89\x4C\xD9\x0C\x92\x99\x25\xEA\xC5\x0A\xE9\xA9\x25\x25\x99\x79\xE9\x0A\x19\xF9\x25\x0A\x99\x79\x0A\x19\xA9\x45\xA9\x7A\x59\x89\xCC\x59\x00\xDC\xF7\x0B\xD9")).toEqual(expected);
});

// TODO: unit tests for all the objects