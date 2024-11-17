type decodeOptions = {
	bigintsAsStrings?: boolean;
};

type encodeOptions = {
	compress?: boolean;
};

declare module "zerlpack" {
	export function decode(buffer: Uint8Array, options?: decodeOptions): any;
	export function unpack(buffer: Uint8Array, options?: decodeOptions): any;

	export function encode(value: any, options?: encodeOptions): Uint8Array;
	export function pack(value: any, options?: encodeOptions): Uint8Array;
}