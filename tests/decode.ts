import { expect, test } from "vitest";

const zerl = require("../index.js");

function dec(array: number[]) {
	return zerl.decode(new Uint8Array(array));
}

function decBin(binary: string) {
	return zerl.decode(Buffer.from(binary, "binary"));
}

function stringToArray(str: string) {
	return new Uint8Array(str.split("").map((c) => c.charCodeAt(0)));
}

test("Fails to construct a Decoder", () => {
	expect(() => dec([])).toThrowError("Buffer is empty");
	expect(() => dec([0])).toThrowError("Wrong format version");
	expect(() => dec([131])).toThrowError("Buffer size mismatch");
});

test("Fails to decode a buffer with items leftover", () => {
	expect(() => dec([131, 97, 0, 69])).toThrowError("Buffer size mismatch: Items leftover.");
});

test("Fails to decode an invalid tag", () => {
	expect(() => dec([131, 32, 0, 0, 0, 0])).toThrowError("Unknown tag");
});

test("Fails to decode unsupported tags", () => {
	expect(() => dec([131, 80])).toThrowError("Compressed data is not supported");
	expect(() => dec([131, 68])).toThrowError("Distribution header is not supported");
	expect(() => dec([131, 69])).toThrowError("Distribution header is not supported");
	expect(() => dec([131, 77])).toThrowError("Bit binary is not supported");
	expect(() => dec([131, 82])).toThrowError("Atom cache ref is not supported");
})

test("Decodes an empty array", () => {
	expect(dec([131, 106])).toEqual([]);
});

test("Decodes an Integer", () => {
	expect(dec([131, 98, 0, 0, 0, 0])).toEqual(0);
	expect(dec([131, 98, 0, 0, 0, 1])).toEqual(1);
	expect(dec([131, 98, 255, 255, 255, 255])).toEqual(-1);
	expect(dec([131, 98, 128, 0, 0, 0])).toEqual(-2_147_483_648);
	expect(dec([131, 98, 127, 255, 255, 255])).toEqual(2_147_483_647);

	expect(() => dec([131, 98, 128, 0, 0])).toThrowError("Buffer size mismatch");
});

test("Decodes a Small Integer", () => {
	expect(dec([131, 97, 0])).toEqual(0);
	expect(dec([131, 97, 1])).toEqual(1);
	expect(dec([131, 97, 255])).toEqual(255);

	expect(() => dec([131, 97])).toThrowError("Buffer size mismatch");
});

test("Decodes atom", () => {
	expect(dec([131, 100, 0, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(dec([131, 100, 0, 4, ...stringToArray("true")])).toEqual(true);
	expect(dec([131, 100, 0, 5, ...stringToArray("false")])).toEqual(false);
	expect(dec([131, 100, 0, 3, ...stringToArray("nil")])).toEqual(null);
	expect(dec([131, 100, 0, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => dec([131, 100, 0, 1])).toThrowError("Buffer size mismatch");

});

test("Decodes small atom", () => {
	expect(dec([131, 115, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(dec([131, 115, 4, ...stringToArray("true")])).toEqual(true);
	expect(dec([131, 115, 5, ...stringToArray("false")])).toEqual(false);
	expect(dec([131, 115, 3, ...stringToArray("nil")])).toEqual(null);
	expect(dec([131, 115, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => dec([131, 115, 1])).toThrowError("Buffer size mismatch");
});

test("Decodes Utf8 atom", () => {
	expect(dec([131, 118, 0, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(dec([131, 118, 0, 4, ...stringToArray("true")])).toEqual(true);
	expect(dec([131, 118, 0, 5, ...stringToArray("false")])).toEqual(false);
	expect(dec([131, 118, 0, 3, ...stringToArray("nil")])).toEqual(null);
	expect(dec([131, 118, 0, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => dec([131, 118, 0, 1])).toThrowError("Buffer size mismatch");
});

test("Decodes small Utf8 atom", () => {
	expect(dec([131, 119, 4, ...stringToArray("atom")])).toEqual("atom");
	expect(dec([131, 119, 4, ...stringToArray("true")])).toEqual(true);
	expect(dec([131, 119, 5, ...stringToArray("false")])).toEqual(false);
	expect(dec([131, 119, 3, ...stringToArray("nil")])).toEqual(null);
	expect(dec([131, 119, 4, ...stringToArray("null")])).toEqual(null);
	expect(() => dec([131, 119, 1])).toThrowError("Buffer size mismatch");

	// TODO: test utf8 somehow? no idea.
});

test("Decodes binary as string", () => {
	expect(dec([131, 109, 0, 0, 0, 6, ...stringToArray("binary")])).toEqual("binary");
	expect(dec([131, 109, 0, 0, 0, 4, ...stringToArray("true")])).toEqual("true");
	expect(() => dec([131, 109, 0, 0, 0, 1])).toThrowError("Buffer size mismatch");
});


test("Decodes small Tuple", () => {
	expect(dec([131, 104, 1, 106])).toEqual([[]]);
	expect(dec([131, 104, 2, 106, 106])).toEqual([[], []]);
	expect(() => dec([131, 104, 1])).toThrowError("Buffer size mismatch");
});

test("Decodes large Tuple", () => {
	expect(dec([131, 105, 0, 0, 0, 1, 106])).toEqual([[]]);
	expect(dec([131, 105, 0, 0, 0, 2, 106, 106])).toEqual([[], []]);
	expect(() => dec([131, 105, 0, 0, 0, 1])).toThrowError("Buffer size mismatch");
});

test("Decodes old Float", () => {
	expect(decBin("\x83c2.50000000000000000000e+00\x00\x00\x00\x00\x00")).toEqual(2.5);
	expect(decBin("\x83c200000.50000000000000000000e+00")).toEqual(200000.5);
	expect(decBin("\x83c5.15121238412343125000e+13\x00\x00\x00\x00\x00")).toEqual(51512123841234.31423412341435123412341342);
	expect(() => dec([131, 99, 0])).toThrowError("Buffer size mismatch");
});

test("Decodes new Float", () => {
	expect(decBin("\x83F\x40\x04\x00\x00\x00\x00\x00\x00")).toEqual(2.5);
	expect(decBin("\x83F\x42\xC7\x6C\xCC\xEB\xED\x69\x28")).toEqual(51512123841234.31423412341435123412341342)
	expect(() => dec([131, 70, 0])).toThrowError("Buffer size mismatch");
});

test("Decodes small Big", () => {
	expect(dec([131, 110, 1, 0, 0])).toEqual(0n);
	expect(dec([131, 110, 1, 0, 1])).toEqual(1n);
	expect(dec([131, 110, 1, 1, 1])).toEqual(-1n);

	expect(dec([131, 110, 0, 0])).toEqual(0n);
	expect(dec([131, 110, 0, 1])).toEqual(-0n);

	expect(dec([131, 110, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0])).toEqual(1n);
	expect(dec([131, 110, 9, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0])).toEqual(257n);
	expect(dec([131, 110, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1])).toEqual(18446744073709551617n);

	expect(() => dec([131, 110])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 110, 0, 0, 1])).toThrowError("Buffer size mismatch");
})

test("Decodes large Big", () => {
	expect(dec([131, 111, 0, 0, 0, 1, 0, 0])).toEqual(0n);
	expect(dec([131, 111, 0, 0, 0, 1, 0, 1])).toEqual(1n);
	expect(dec([131, 111, 0, 0, 0, 1, 1, 1])).toEqual(-1n);

	expect(dec([131, 111, 0, 0, 0, 0, 0])).toEqual(0n);
	expect(dec([131, 111, 0, 0, 0, 0, 1])).toEqual(-0n);

	expect(dec([131, 111, 0, 0, 0, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0])).toEqual(1n);
	expect(dec([131, 111, 0, 0, 0, 9, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0])).toEqual(257n);
	expect(dec([131, 111, 0, 0, 0, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1])).toEqual(18446744073709551617n);

	expect(() => dec([131, 111, 0, 0, 0])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 111, 0, 0, 0, 0, 0, 1])).toThrowError("Buffer size mismatch");
});

test("Decodes list", () => {
	expect(dec([131, 108, 0, 0, 0, 0, 106])).toEqual([]);
	expect(dec([131, 108, 0, 0, 0, 1, 106, 106])).toEqual([[]]);
	expect(dec([131, 108, 0, 0, 0, 2, 106, 106, 106])).toEqual([[], []]);

	expect(() => dec([131, 108, 0, 0, 0, 1, 106, 0])).toThrowError("Invalid tail");
	expect(() => dec([131, 108, 0, 0, 0, 1, 106])).toThrowError("Buffer size mismatch");
});

test("Decodes map", () => {
	expect(dec([131, 116, 0, 0, 0, 0])).toEqual({});
	expect(dec([131, 116, 0, 0, 0, 1, 97, 0, 106])).toEqual({ 0: [] });
	expect(dec([131, 116, 0, 0, 0, 2, 97, 0, 106, 97, 1, 106])).toEqual({ 0: [], 1: [] });
	expect(dec([131, 116, 0, 0, 0, 1, 115, 1, 97, 106])).toEqual({ "a": [] });
	expect(dec([131, 116, 0, 0, 0, 2, 115, 1, 97, 106, 115, 1, 98, 106])).toEqual({ "a": [], "b": [] });

	expect(() => dec([131, 116, 0, 0, 0])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 116, 0, 0, 0, 1])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 116, 0, 0, 0, 1, 97, 0])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 116, 0, 0, 0, 1, 97, 0, 97])).toThrowError("Buffer size mismatch");
});

test("Decodes string as array of integers", () => {
	expect(dec([131, 107, 0, 0])).toEqual([]);
	expect(dec([131, 107, 0, 1, 97])).toEqual([97]);
	expect(dec([131, 107, 0, 2, 97, 98])).toEqual([97, 98]);

	expect(() => dec([131, 107, 0])).toThrowError("Buffer size mismatch");
	expect(() => dec([131, 107, 0, 1])).toThrowError("Buffer size mismatch");
});

// TODO: unit tests for all the objects