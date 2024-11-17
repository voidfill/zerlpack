declare module "zerlpack" {
	export function decode(buffer: Uint8Array): any;
	export function unpack(buffer: Uint8Array): any;

	export function encode(value: any, compress?: boolean): Buffer;
	export function pack(value: any, compress?: boolean): Buffer;
}